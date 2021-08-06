part of bakecode.engine;

class BakeCodeEngine {
  /// This class shall not be instantiated more than once.
  BakeCodeEngine._();

  /// The instance of BakeCode Engine.
  static late final instance = BakeCodeEngine._();

  /// Whether the engine is initialized or not. Avoid accessing other members
  /// of this instance if the value is `false`.
  ///
  /// See also:
  /// * [initialize], to initialize the engine.
  bool isInitialized = false;

  /// Initializes the engine instance by loading the ecosystem configuration,
  /// initializing the BSI layer, and registering mDNS discovery.
  Future<bool> initialize() async {
    ecosystem = await Ecosystem.loadFromFile();

    await BSI.initialize(
      const BSIConfig(
        name: 'eni',
        server: '192.168.43.20',
        port: 1883,
        username: 'user',
        password: 'iL0v3MoonGaYoung',
      ),
    );

    return isInitialized = true;
  }

  late final Ecosystem ecosystem;
}
