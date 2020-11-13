import 'dart:async';
import 'dart:io';

import 'package:bakecode/bakecode.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

export 'broadcast_service.dart';
export 'connection.dart';
export 'service_message.dart';

/// **BakeCode Services Interconnect Layer**
///
/// This singleton presents a set of methods to interact with the *BakeCode
/// Ecosystem* using MQTT as the L7 Application Layer Protocol.
@sealed
class BSI {
  /// Private generic empty constructor for singleton implementation.
  const BSI._();

  /// The singleton instance of BakeCode Services Interconnect Layer.
  static final instance = BSI._();

  /// Redirecting factory constructor to the singleton instance.
  factory BSI() => instance;

  void hookService({@required Service service}) {
    // TODO: do this...
  }

  void unhookService({@required Service service}) {
    // TODO: do this...
  }
}

@sealed
class _Mqtt {
  /// Private generic empty constructor for singleton implementation.
  _Mqtt._();

  /// The singleton instance.
  static final instance = _Mqtt._();

  /// Redirecting factory constructor to the singleton instance.
  factory _Mqtt() => instance;

  /// Instance of [MqttServerClient].
  final MqttServerClient client = MqttServerClient('0.0.0.0', 'bakecode');

  /// QOS to be used for all messages.
  final MqttQos qos = MqttQos.exactlyOnce;

  /// Receives and broadcasts subscriptions to appropriate listeners.
  ///
  /// The received subscription update's topic and payload is extracted and
  /// then broadcasts the payload to it's appropriate topic listeners.
  static void onReceive(List<MqttReceivedMessage<MqttMessage>> packet) {
    final String topic = packet[0].topic;
    final String message = MqttPublishPayload.bytesToStringAsString(
        (packet[0].payload as MqttPublishMessage).payload.message);

    _subscriberSinks[topic].forEach((sink) => sink.add(message));
  }

  /// Connects the [_client] to the broker.
  static Future<MqttClientConnectionStatus> _connect() async {
    try {
      return await _client.connect();
    } on NoConnectionException catch (e) {
      print(e);
      _client.disconnect();
    } on SocketException catch (e) {
      print(e);
      _client.disconnect();
    }
    return _client.connectionStatus;
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

    print((await _connect()).state);

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
