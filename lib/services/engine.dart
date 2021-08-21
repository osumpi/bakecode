part of bakecode.engine;

class BakecodeEngine extends Service {
  BakecodeEngine() : super(File('config/engine.yaml'));

  late final Ecosystem ecosystem;
}
