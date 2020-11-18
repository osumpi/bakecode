import 'dart:async';

import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

import 'flow_context.dart';

@immutable
abstract class InputConnection {
  Stream<FlowContext> get stream;
}

@immutable
abstract class OutputConnection {
  Sink<FlowContext> get sink;

  void connectTo(Node node);
}

@immutable
class Connection with InputConnection, OutputConnection {
  final _flow = StreamController<FlowContext>();

  @override
  Sink<FlowContext> get sink => _flow.sink;

  @override
  Stream<FlowContext> get stream => _flow.stream;

  final awaiters = <Node>[];

  @override
  void connectTo(Node receiver) => awaiters.add(receiver..listenTo(this));
}
