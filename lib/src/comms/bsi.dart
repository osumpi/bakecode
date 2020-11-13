import 'dart:async';

import 'package:bakecode/bakecode.dart';
import 'package:bakecode/src/comms/mqtt/mqtt.dart';
import 'package:meta/meta.dart';

export 'broadcast_service.dart';
export 'mqtt/mqtt_connection.dart';
export 'service_message.dart';

/// **BakeCode Services Interconnect Layer**
///
/// This singleton presents a set of methods to interact with the *BakeCode
/// Ecosystem* using MQTT as the L7 Application Layer Protocol.
@sealed
class BSI {
  /// Private generic empty constructor for singleton implementation.
  BSI._();

  /// The singleton instance of BakeCode Services Interconnect Layer.
  static final instance = BSI._();

  /// Redirecting factory constructor to the singleton instance.
  factory BSI() => instance;

  final hookedServices = <String, StreamSink<ServiceMessage>>{};

  void hook(Service service, {@required StreamSink<ServiceMessage> sink}) =>
      hookedServices.putIfAbsent('${service.reference}', () => sink);

  void unhook(Service service) =>
      hookedServices.remove(service.reference)?.close();

  void onReceiveCallback(String topic, String packet) =>
      hookedServices[topic]?.add(ServiceMessage.fromJSONString(packet));
}
