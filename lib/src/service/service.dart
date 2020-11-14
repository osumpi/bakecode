import 'dart:async';

import 'package:bakecode/src/service/reference.dart';
import 'package:bakecode/src/comms/bsi.dart';
import 'package:meta/meta.dart';

abstract class Service {
  /// Default constructor for [Service].
  ///
  /// Registers onMessage stream controller's sink for listening to messages
  /// related to [context].
  Service() {
    BSI.instance.hook(this, sink: _onReceiveSink);
  }

  /// Provides a handle for BakeCode services.
  ///
  /// Path makes every [Service]s to be identifiable.
  ServiceReference get reference;

  /// [ServiceReference] of the state of this service.
  ///
  /// All [StateService] associated w/ a [Service] resides here.
  ServiceReference get state => reference.child('state');

  /// Exposes all incoming messages for this service.
  ///
  /// Listen to messages that is addressed to this service.
  Stream<ServiceMessage> get onReceive => _onReceiveController.stream;

  /// Sends a broadcast message.
  ///
  /// All nodes in the bakecode ecosystem may listen to the broadcast messages.
  @mustCallSuper
  void broadcast(String message) => BSI.instance
      .send(ServiceMessage.asBroadcast(source: reference, message: message));

  /// Publishes a [message] on [topic].
  /// By default [topic] is [path].
  @mustCallSuper
  void notify(ServiceReference to, {@required String message}) =>
      BSI.instance.send(ServiceMessage(
          source: reference, destinations: [to], message: message));

  /// Sink of [_onReceiveController].
  StreamSink<ServiceMessage> get _onReceiveSink => _onReceiveController.sink;

  /// Stream controller for on message events.
  final _onReceiveController = StreamController<ServiceMessage>();
}
