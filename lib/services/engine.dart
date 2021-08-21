part of bakecode.engine;

class BakecodeEngine extends Service {
  BakecodeEngine() : super(File('config/engine.yaml'));

  late final State<Ecosystem> ecosystem = state<Ecosystem>('map');

  @override
  Future<void> initState() async {
    super.initState();

    runner.addCommand(_InstantiatedCommand());

    ecosystem.set(await Ecosystem.loadFromFile());
  }

  @override
  void onMessageReceived(ServiceMessage message) {
    super.onMessageReceived(message);

    try {
      runner.run(message.arguments);
    } catch (exception) {
      log('$exception');
    }
  }

  late final runner = CommandRunner(config.name, config.description);
}

class _InstantiatedCommand extends Command {
  final name = 'instantiated';
  final description = '';

  _InstantiatedCommand() {
    addSubcommand(_InstantiatedServiceCommand());
  }

  run() {
    return super.run();
  }
}

class _InstantiatedServiceCommand extends Command {
  @override
  final name = 'service';

  @override
  final description = '';

  _InstantiatedServiceCommand() {
    argParser.addOption('name', mandatory: true);
    argParser.addOption('id', mandatory: true);
    argParser.addOption('address', mandatory: true);
  }

  @override
  FutureOr? run() {
    final name = argResults!['name'] as String;
    final id = argResults!['id'] as String;
    final address = Address(argResults!['address'] as String);

    // TODO: invoke ecosystem.addService(name, id, address);

    return super.run();
  }
}
