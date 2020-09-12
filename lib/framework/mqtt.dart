import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// MQTT handling layer.
///
/// This class presents a set of methods for the Kernel and Runtime to interact
/// with the BakeCode Ecosystem.
@sealed
class MqttRuntime {
  /// Factory redirecting to [MqttRuntime.instance].
  factory MqttRuntime() => instance;

  /// Instance of Singleton [MqttRuntime].
  static final instance = MqttRuntime._();

  /// Private generative constructor.
  MqttRuntime._();

  /// The mqtt client instance.
  final MqttServerClient _client = MqttServerClient('localhost', 'BCRT');

  /// The default Quality of Service to be used.
  /// [MqttQos.atLeastOnce]
  static const MqttQos _qos = MqttQos.atLeastOnce;

  /// Initializes the MQTT handler.
  void init({
    @required String runtimeInstanceID,
    @required String server,
    int port = 1883,
    String username,
    String password,
  }) {
    assert(runtimeInstanceID != null && runtimeInstanceID != '');
    assert(server != null && server != '');
    assert(port != null);

    _client
          ..server = server
          ..port = port
          ..clientIdentifier = 'BCRT-$runtimeInstanceID'
          ..autoReconnect = true
          ..logging(on: false)
          ..keepAlivePeriod = 4
          ..onAutoReconnect = _updateConnectionState
          ..onConnected = _updateConnectionState
          ..onDisconnected = _updateConnectionState
          ..onBadCertificate = (s) => true // TODO: impl. bad certificate
        // ..onSubscribed =
        // ..onUnsubscribed = _onUnsubscribed
        // ..onSubscribeFail = _onSubscribeFail
        // ..pongCallback = _pong
        // ..published.listen(_onPublished)
        ;

    _client.connectionMessage = MqttConnectMessage()
        .keepAliveFor(20)
        .authenticateAs(username, password)
        .withWillTopic('bakecode/runtime/$runtimeInstanceID/will')
        .withWillMessage('DISCON')
        .withWillQos(_qos);

    _client.connect();
  }

  /// Publish a message.
  ///
  /// Publishes the [message] to the specified [topic].
  /// [topic] should follow MQTT Topic Guidelines.
  ///
  /// The QOS used by default will be [MqttQos.atLeastOnce].
  /// However this can be overriden by specifying the [qos].
  void publish({
    @required String topic,
    @required String message,
    MqttQos qos = _qos,
  }) =>
      // _client.publishMessage(topic, qos, data);
      print('$topic ==> $message');

  /// Updates the `_connectionStateStreamController` w/ latest state.
  void _updateConnectionState() =>
      _connectionStateStreamController.sink.add(_client.connectionStatus.state);

  /// `StreamController` for `client`'s connection state.
  final _connectionStateStreamController =
      StreamController<MqttConnectionState>();

  /// Broadcast stream for client's connection state.
  Stream<MqttConnectionState> get connectionStateStream =>
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

//   /// Connects the [MqttRuntime] [client] [instance] to the broker service.
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
//   MqttRuntime._() {
//     /// Listen to client updates and implement callbacks to listeners.
//     client.updates.listen((List<MqttReceivedMessage<MqttMessage>> data) {
//       data[0] as MqttPayload;
//       subscriptionCallbacks[data[0].topic].forEach((fn) => fn(
//           (AsciiPayloadConverter().convertFromBytes(
//               (data[0].payload as MqttPublishMessage).payload.message))));
//     });
//     connect();
//   }

//   /// The current [MqttRuntime] singleton instance.
//   static final MqttRuntime instance = MqttRuntime._();

//   /// Returns the [MqttRuntime] instance.
//   factory MqttRuntime() => instance;
// }
