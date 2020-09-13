import 'dart:async';

import 'package:bakecode/framework/context.dart';
import 'package:bakecode/framework/mqtt.dart';
import 'package:meta/meta.dart';

abstract class BakeCodeService {
  BakeCodeService() {
    Mqtt.addListener(topic: context.path, sink: _onMessageSink);
  }

  /// Provides a handle for BakeCode services.
  ///
  /// Context makes every [BakeCodeService]s to be identifiable.
  Context get context;

  /// Publishes a [message] on [topic].
  ///
  /// By default [topic] is [this.context].
  @mustCallSuper
  void publish(String message, {Context to}) =>
      Mqtt.publish(message, to: (to ?? context).path);

  StreamSink<String> get _onMessageSink => _onMessageStreamController.sink;

  Stream<String> get onMessage => _onMessageStreamController.stream;

  final _onMessageStreamController = StreamController<String>();
}
