import 'dart:async';

import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

import 'flow_context.dart';

@immutable
class Connection {
  final endPoints = <Node>[];

  final _flowContextController = StreamController<FlowContext>();

  Sink<FlowContext> get _contextSink => _flowContextController.sink;

  Stream<FlowContext> get _contextStream => _flowContextController.stream;

  void addEndPoint(Node node) {
    endPoints.add(node);
    _contextStream.listen((context) async => node.output._contextSink
      ..add(await node.run(context))
      ..close());
  }

  bool get isClosure => endPoints.isEmpty;
}
