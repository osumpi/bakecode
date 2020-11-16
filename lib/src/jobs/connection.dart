import 'dart:async';

import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

import 'flow_context.dart';

@immutable
@sealed
class Connection {
  final endPoints = <Node>[];

  final _flow = StreamController<FlowContext>();

  void addEndPoint(Node node) {
    endPoints.add(node);
    _flow.stream.listen((context) async => node.output._flow.sink
      ..add(await node.run(context))
      ..close());
  }

  bool get isClosure => endPoints.isEmpty;
}
