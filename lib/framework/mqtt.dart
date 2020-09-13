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
    if (!_subscriberSinks.containsKey(topic)) {
      _subscriberSinks[topic] = List();
    }

    _subscriberSinks[topic].add(sink);
  }

  /// Instance of [MqttServerClient].
  ///
  /// Is the main interfacing client for this kernel.
  static final MqttServerClient _client = MqttServerClient('localhost', 'BCRT');

  /// The default QOS level to be used is [MqttQos.atLeastOnce].
  static const MqttQos _qos = MqttQos.atLeastOnce;

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

    _subscriberSinks[topic]?.map((sink) => sink.add(message));
  }

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

  static void _clientConnected() {
    _subscriberSinks.keys.map((e) => _client.subscribe(e, _qos));

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
          ..onConnected = _clientConnected
          ..onDisconnected = _updateConnectionState
          ..onBadCertificate = (s) => true // TODO: impl. bad certificate
        // ..onSubscribed =
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

    _client.updates.listen(_subscriptionReceived);

    connectionStateStream.listen(print);

    // Subscribe and setup streams...

    // updates listen...
    /// Listen to client updates and implement callbacks to listeners.
    ///

    // published.listen
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
  static Stream<MqttConnectionState> get connectionStateStream =>
      _connectionStateStreamController.stream.asBroadcastStream();
}

// ///
// ///
// ///
// ///
// ///
// @immutable
// class a {
//   /// MQTT Quality of Service level of all transactions.
//   final MqttQos _qos = MqttQos.atMostOnce;

//   /// Current [connectionState] of [client].
//   static MqttConnectionState connectionState = MqttConnectionState.disconnected;

//   /// The [MqttClient] instance of this runtime.
//   static final MqttClient client = MqttClient.withPort(server, 'bakecode', port)
//     ..logging(on: true)
//     ..keepAlivePeriod = 20
//     ..autoReconnect = true
//     ..onAutoReconnect = onAutoReconnect
//     ..onConnected = onConnected
//     ..onDisconnected = onDisconnected
//     ..onSubscribed = onSubscribed
//     ..onUnsubscribed = onUnsubscribed;

//   /// Subscriptions and it's onMessageReceived callbacks.
//   static final Map<String, List<void Function(String message)>>
//       subscriptionCallbacks = {};

//   /// Subscribes and adds callback.
//   void addSubscription(String topic,
//       {@required void Function(String message) onMessage}) {
//     /// Appends [onMessageCallback] to callback stack of the topic.
//     subscriptionCallbacks.containsKey(topic)
//         ? subscriptionCallbacks[topic].add(onMessage)
//         : subscriptionCallbacks[topic] = [onMessage];

//     /// subscribe [client] to the [topic].
//     client.subscribe(topic, _qos);
//   }

//   /// Publish [message] to [topic].
//   void publishMessage({
//     @required String topic,
//     @required String message,
//   }) =>
//       client.publishMessage(topic, _qos,
//           (MqttClientPayloadBuilder()..addString(message)).payload);

//   /// Callback function when [client] gets connected to the broker.
//   static void onConnected() {
//     connectionState = MqttConnectionState.connected;
//   }

//   /// Callback function when [client] automatically tries to reconnects with
//   /// the broker.
//   /// Callback is invoked before auto reconnect is performed.
//   static void onAutoReconnect() {
//     connectionState = MqttConnectionState.connecting;
//   }

//   /// Callback function when [client] gets disconnected from the broker.
//   static void onDisconnected() {
//     connectionState = MqttConnectionState.disconnected;
//   }

//   /// Callback function when [client] sucesfully subscribes to a topic.
//   /// TODO: implement [onSubscribed]
//   static void onSubscribed(String callback) {}

//   /// Callback function when [client] sucesfully unsibscribes from a topic.
//   /// TODO: implement [onUnsubcribed]
//   static void onUnsubscribed(String callback) {}

//   /// Connects the [Mqtt] [client] [instance] to the broker service.
//   // TODO: implement loggin;
//   static Future<void> connect() async {
//     try {
//       connectionState = MqttConnectionState.connecting;
//       connectionState = (await client.connect(username, password)).state;
//     } catch (e) {
//       connectionState = MqttConnectionState.faulted;
//     }
//   }

//   /// Private constructor
//   Mqtt._() {
//     /// Listen to client updates and implement callbacks to listeners.
//     client.updates.listen((List<MqttReceivedMessage<MqttMessage>> data) {
//       data[0] as MqttPayload;
//       subscriptionCallbacks[data[0].topic].forEach((fn) => fn(
//           (AsciiPayloadConverter().convertFromBytes(
//               (data[0].payload as MqttPublishMessage).payload.message))));
//     });
//     connect();
//   }

//   /// The current [Mqtt] singleton instance.
//   static final Mqtt instance = Mqtt._();

//   /// Returns the [Mqtt] instance.
//   factory Mqtt() => instance;
// }
