import 'package:bakecode/src/jobs/connection.dart';
import 'package:bakecode/src/jobs/flow_context.dart';

import 'node.dart';

export 'flow_context.dart';
export 'connection.dart';
export 'node.dart';

class Job extends Node {
  @override
  Future<FlowContext> run(FlowContext context) {
    // TODO: implement run
    throw UnimplementedError();
  }
}
