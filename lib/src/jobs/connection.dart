import 'dart:async';

import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

import 'flow_context.dart';

@immutable
@sealed
class Connection {
  final _flow = StreamController<FlowContext>();
}

class InputConnection extends Connection {
  Stream<FlowContext> get stream => _flow.stream;
}

class OutputConnection extends Connection {
  Sink<FlowContext> get sink => _flow.sink;
}
