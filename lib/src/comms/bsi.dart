import 'dart:async';

import 'package:bakecode/bakecode.dart';
import 'package:bakecode/src/comms/mqtt/mqtt.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';

export 'broadcast_service.dart';
export 'mqtt/mqtt_connection.dart';
export 'service_message.dart';

/// **BakeCode Services Interconnect Layer**
///
/// This singleton presents a set of methods to interact with the *BakeCode
/// Ecosystem* using MQTT as the L7 Application Layer Protocol.
@sealed
class BSI {
  /// Private generative constructor for singleton implementation.
  ///
  /// Sets up the [outbox]'s [StreamController] and hook's listener to Mqtt's
  /// connection state.
  BSI._() {
    var subscription = _outgoingMessageController.stream.listen(_send)..pause();

    Mqtt().connectionState.listen((connectionState) {
      if (connectionState == MqttConnectionState.connected) {
        subscription.resume();
        log.i('''
        Outbox has been resumed.
        
        Reason: Connection state has changed to: $connectionState''');
      } else {
        subscription.pause();

        log.w('''
        Outbox has been haulted.
        
        Reason: Connection state has changed to: $connectionState''');
      }
    });
  }

  /// The singleton instance of BakeCode Services Interconnect Layer.
  static final instance = BSI._();

  /// Redirecting factory constructor to the singleton instance.
  factory BSI() => instance;

  /// StreamController for outgoing messages.
  ///
  /// Services can add [ServiceMessages] to the [outbox] and the listener of
  /// this stream shall send the messages when connection is available.
  final _outgoingMessageController = StreamController<ServiceMessage>();

  /// The outbox for messages to be sent.
  ///
  /// Messages will be sent immediatley if connection to broker is available,
  /// else will be haulted.
  ///
  /// On reconnect, previous messages may be discarded depending on the setting
  /// specified in the configuration file.
  /// Configuration: `BSI::drain outbox on reconnect`.
  Sink<ServiceMessage> get outbox => _outgoingMessageController.sink;

  /// Sends [message] to the corresponding destinations specified in packet.
  void _send(ServiceMessage message) => message.destinations.forEach(
      (destination) => Mqtt.instance.publish('$message', to: '$destination'));

  final hookedServices = <String, StreamSink<ServiceMessage>>{};

  void hook(Service service, {@required StreamSink<ServiceMessage> sink}) =>
      hookedServices.putIfAbsent('${service.reference}', () => sink);

  void unhook(Service service) =>
      hookedServices.remove(service.reference)?.close();

  void onReceiveCallback(String topic, String packet) =>
      hookedServices[topic]?.add(ServiceMessage.fromJSONString(packet));
}
