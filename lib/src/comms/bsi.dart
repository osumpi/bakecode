import 'package:bakecode/bakecode.dart';
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

  void onReceiveCallback(String topic, String packet) {}
}
