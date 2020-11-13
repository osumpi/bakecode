import 'dart:async';

import 'package:bakecode/src/service_reference.dart';
import 'package:bakecode/src/comms/bsi.dart';
import 'package:meta/meta.dart';

abstract class Service {
  /// Default constructor for [Service].
  ///
  /// Registers onMessage stream controller's sink for listening to messages
  /// related to [context].
  Service() {
    Mqtt.addListener(topic: '$path', sink: _onReceiveSink);
    _onReceiveController.stream.listen(print);
  }

  /// Provides a handle for BakeCode services.
  ///
  /// Path makes every [Service]s to be identifiable.
  ServiceReference get reference;

  /// Exposes all incoming messages for this service.
  ///
  /// Listen to messages that is addressed to this service.
  Stream<String> get onReceiveStream => _onReceiveController.stream;

  /// Publishes a [message] on [topic].
  /// By default [topic] is [path].
  @mustCallSuper
  void nofify(ServiceReference to, {@required String msg}) =>
      // TODO: add envelope to msg
      Mqtt.publish(msg, topic: to);

  /// Sink of [_onReceiveController].
  StreamSink<String> get _onReceiveSink => _onReceiveController.sink;

  /// Stream controller for on message events.
  final _onReceiveController = StreamController<String>();
}
