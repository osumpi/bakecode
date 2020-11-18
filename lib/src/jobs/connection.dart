import 'dart:async';

import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

import 'flow_context.dart';

/// This asbtract class gives access to the stream of the [Connection].
@immutable
abstract class InputConnection {
  /// The listenable stream of the [Connection._flow].
  Stream<FlowContext> get stream;
}

/// This abstract class presents functionalities to connect the output to
/// another node gives access to the sink of the [Connection].
@immutable
abstract class OutputConnection {
  /// The sink of the [Connection._flow].
  Sink<FlowContext> get sink;

  /// Makes a forward connection to a Node.
  void connectTo(Node node);
}

/// The element that links multiple [Node]s.
@immutable
class Connection with InputConnection, OutputConnection {
  final _flow = StreamController<FlowContext>();

  @override
  Sink<FlowContext> get sink => _flow.sink;

  @override
  Stream<FlowContext> get stream => _flow.stream.asBroadcastStream();

  final awaiters = <Node>[];

  @override
  void connectTo(Node receiver) => awaiters.add(receiver..await(this));
}
