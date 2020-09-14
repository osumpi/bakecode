import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// MQTT handling layer.
///
/// This class presents a set of methods for the Kernel and Runtime to interact
/// with the BakeCode Ecosystem.
@sealed
class Mqtt {
  /// Notifies the [sink] for every payload received in [topic].
  ///
  /// If the topic is new, Mqtt client makes a subscription on that topic and
  /// then adds the listener to the list.
  static void addListener({
    @required String topic,
    @required StreamSink<String> sink,
  }) {
    if (!_subscriberSinks.containsKey(topic)) _subscriberSinks[topic] = List();
    _subscriberSinks[topic].add(sink);
  }

  /// Instance of [MqttServerClient].
  ///
  /// Is the main interfacing client for this kernel.
  static final MqttServerClient _client = MqttServerClient('localhost', 'BCRT');

  /// The default QOS level to be used is [MqttQos.atLeastOnce].
  static const MqttQos _qos = MqttQos.atMostOnce;

  /// Contains all [BakeCodeService] subscriber's sink for each topic.
  ///
  /// A Key-value pair map where keys are the topics and values are the
  /// corresponding listener sinks.
  static final Map<String, List<StreamSink<String>>> _subscriberSinks = Map();

  /// Receives and broadcasts subscriptions to appropriate listeners.
  ///
  /// The received subscription update's topic and payload is extracted and
  /// then broadcasts the payload to it's appropriate topic listeners.
  static void _subscriptionReceived(
      List<MqttReceivedMessage<MqttMessage>> packet) {
    final String topic = packet[0].topic;
    final String message = MqttPublishPayload.bytesToStringAsString(
        (packet[0].payload as MqttPublishMessage).payload.message);

    _subscriberSinks[topic].forEach((sink) => sink.add(message));
  }

  /// Connects the [_client] to the broker.
  static void _connect() async {
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      print(e);
      _client.disconnect();
    } on SocketException catch (e) {
      print(e);
      _client.disconnect();
    }
  }

  static void _subscribe(String topic) => _client.subscribe(topic, _qos);

  /// Subscribes the topics needed by the listeners, and binds the update
  /// listener everytime the [_client] connects to the broker.
  static void _onClientConnected() {
    _subscriberSinks.keys.forEach(_subscribe);
    _client.updates.listen(_subscriptionReceived);
    _updateConnectionState();
  }

  /// Initializes the MQTT handler.
  static void init({
    @required String runtimeInstanceID,
    @required String server,
    int port = 1883,
    String username,
    String password,
  }) async {
    assert(runtimeInstanceID != null && runtimeInstanceID != '');
    assert(server != null && server != '');
    assert(port != null);

    _client
          ..server = server
          ..port = port
          ..autoReconnect = true
          ..logging(on: false)
          ..keepAlivePeriod = 20
          ..onAutoReconnect = _updateConnectionState
          ..onConnected = _onClientConnected
          ..onDisconnected = _updateConnectionState
          ..onBadCertificate = ((s) => true)
          ..onSubscribed = print
        // ..onUnsubscribed = _onUnsubscribed
        // ..onSubscribeFail = _onSubscribeFail
        // ..pongCallback = _pong
        // ..published.listen(_onPublished)
        ;

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('BCRT - $runtimeInstanceID')
        .keepAliveFor(20)
        .authenticateAs(username, password)
        .withWillTopic('bakecode/runtime/$runtimeInstanceID/will')
        .withWillMessage('DISCON')
        .withWillQos(_qos);

    await _connect();

    // Subscribe and setup streams...

    // updates listen...
    /// Listen to client updates and implement callbacks to listeners.
    ///

    // published.listen

    connectionState.listen(print);
  }

  /// Publish a message.
  ///
  /// Publishes the [message] to the specified [topic].
  /// [topic] should follow MQTT Topic Guidelines.
  ///
  /// The QOS used by default will be [MqttQos.atLeastOnce].
  /// However this can be overriden by specifying the [qos].
  static void publish(String message,
          {@required String to, MqttQos qos = _qos}) =>
      _client.publishMessage(
          to, qos, (MqttClientPayloadBuilder()..addString(message)).payload);

  /// Updates the `_connectionStateStreamController` w/ latest state.
  static void _updateConnectionState() =>
      _connectionStateStreamController.sink.add(_client.connectionStatus.state);

  /// `StreamController` for `client`'s connection state.
  static final _connectionStateStreamController =
      StreamController<MqttConnectionState>();

  /// Broadcast stream for client's connection state.
  static Stream<MqttConnectionState> get connectionState =>
      _connectionStateStreamController.stream.asBroadcastStream();
}
