import 'dart:async';
import 'dart:io';

import 'package:bakecode/bakecode.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

@sealed
class Mqtt {
  /// Private generic empty constructor for singleton implementation.
  Mqtt._();

  /// The singleton instance.
  static final instance = Mqtt._();

  /// Redirecting factory constructor to the singleton instance.
  factory Mqtt() => instance;

  /// Instance of [MqttServerClient].
  final MqttServerClient client = MqttServerClient('0.0.0.0', 'bakecode');

  /// QOS to be used for all messages.
  static const MqttQos qos = MqttQos.exactlyOnce;

  /// Initialize the MQTT layer by specifying [using] with the [MqttConnection]
  /// specifications.
  Future<MqttClientConnectionStatus> initialize({
    @required MqttConnection using,
  }) async {
    assert(using != null);

    log.v("Initializing MQTT layer using: $using");

    client
      ..server = using.broker
      ..port = using.port
      ..keepAlivePeriod = 20
      ..autoReconnect = true
      ..onAutoReconnect = (() => log.v('auto-reconnecting...'))
      ..onAutoReconnected = (() => log.v('auto-reconnected'))
      ..onConnected = onConnected
      ..onDisconnected = (() => log.w('disconnected'))
      ..onBadCertificate = onBadCertificate
      ..onSubscribeFail = ((topic) => log.e('subscription failed'))
      ..onSubscribed = ((topic) => log.d('$topic subscribed'))
      ..onUnsubscribed = ((topic) => log.d('$topic unsubscribed'))
      ..pongCallback = (() => log.v('pong at ${DateTime.now()}'))
      ..published
      ..updates
      ..logging(on: false)
      ..connectionMessage = MqttConnectMessage()
          .withClientIdentifier('bakecode')
          .keepAliveFor(client.keepAlivePeriod)
          .withWillQos(qos)
          .withWillRetain()
          .withClientIdentifier(client.clientIdentifier)
          .withWillMessage('offline')
          .withWillTopic('${BakeCode.instance.reference}')
          .authenticateAs(
            using.authentication_username,
            using.authentication_password,
          );

    return await connect();
  }

  /// Connects the [client] to the broker.
  Future<MqttClientConnectionStatus> connect() async {
    try {
      return await client.connect();
    } on NoConnectionException catch (e) {
      print(e);
      client.disconnect();
    } on SocketException catch (e) {
      print(e);
      client.disconnect();
    }
    return client.connectionStatus;
  }

  /// Received messages are passed to the BSI layer.
  void onReceive(MqttReceivedMessage<MqttMessage> packet) =>
      BSI().onReceiveCallback(
        packet.topic,
        MqttPublishPayload.bytesToStringAsString(
            (packet.payload as MqttPublishMessage).payload.message),
      );

  /// Enqueue failed subscription topics which shall be dequeued onConnect;
  final pendingSubscriptions = <String>[];

  /// Subscribe to a topic.
  void subscribe(String topic) {
    try {
      client.subscribe(topic, qos);
    } catch (e) {
      log.e(e);
      pendingSubscriptions.add(topic);
    }
  }

  // Unsubscribe from a topic.
  void unsubscribe(String topic) {
    try {
      client.unsubscribe(topic);
    } catch (e) {
      log.e(e);
    }
  }

  /// Subscribes failed subscriptions and listen for updates.
  void onConnected() {
    log.d('mqtt::connected');

    pendingSubscriptions.forEach(subscribe);

    client.updates.listen((e) => onReceive(e[0]));

    updateConnectionState();
  }

  bool onBadCertificate(X509Certificate certificate) {
    log.e('bad certificate');
    return false;
  }

  /// Publish a message.
  ///
  /// Publishes the [message] to the specified [topic].
  /// [topic] should follow MQTT Topic Guidelines.
  ///
  /// The QOS used by default will be [MqttQos.atLeastOnce].
  /// However this can be overriden by specifying the [qos].
  int publish(String message, {@required String to}) => client.publishMessage(
      to, qos, (MqttClientPayloadBuilder()..addString(message)).payload);

  /// Updates the `_connectionStateStreamController` w/ latest state.
  void updateConnectionState() =>
      _connectionStateStreamController.sink.add(client.connectionStatus.state);

  /// `StreamController` for `client`'s connection state.
  final _connectionStateStreamController =
      StreamController<MqttConnectionState>();

  /// Broadcast stream for client's connection state.
  Stream<MqttConnectionState> get connectionState =>
      _connectionStateStreamController.stream;
}
