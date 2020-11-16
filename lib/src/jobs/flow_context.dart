import 'package:meta/meta.dart';

@immutable
class FlowContext {
  final String data;

  FlowContext.fromString(this.data);

  toString() => '''
  FlowContext:

  {$data}
  ''';
}
