import 'dart:convert';

import 'package:bakecode/bakecode.dart';
import 'package:bakecode/src/comms/broadcast_service.dart';
import 'package:meta/meta.dart';

@immutable
class ServiceMessage {
  /// The source service of the message.
  final ServiceReference source;

  /// Recipient services of the message.
  final List<ServiceReference> destinations;

  /// The message as string.
  final String message;

  const ServiceMessage({
    @required this.source,
    @required this.destinations,
    @required this.message,
  })  : assert(source != null),
        assert(destinations != null),
        assert(message != null);

  factory ServiceMessage.broadcast({
    @required ServiceReference source,
    @required String message,
  }) =>
      ServiceMessage(
        source: source,
        destinations: [BroadcastService().reference],
        message: message,
      );

  factory ServiceMessage.fromJSONString(String packet) {
    var p = jsonDecode(packet);

    return ServiceMessage(
      source: ServiceReference.fromString(p['source']),
      destinations: p['destination'].map((d) => ServiceReference.fromString(d)),
      message: p['message'].toString(),
    );
  }

  @override
  String toString() => """
  {
    "source": "$source",
    "destinations": $destinations,
    "message": "$message",
  }
  """;
}
