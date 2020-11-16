import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

@immutable
class FlowContext {
  final data;

  FlowContext.fromString(String data)
      : assert(data != null),
        data = loadYaml(data);

  toString() => '''
  FlowContext:

  {$data}
  ''';
}
