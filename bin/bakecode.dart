import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode/bakecode.dart';
import 'package:yaml/yaml.dart';

class RunCommand extends Command {
  @override
  String get name => 'run';

  @override
  List<String> get aliases => ['start', 'launch'];

  @override
  String get description => """
  Launch bakecode ecosystem.

  Uses default config file if not specified. Explicitly specified options override options in config file.
  """;

  RunCommand() {
    argParser.addOption('config-file',
        abbr: 'c', help: "Path to config file", defaultsTo: 'bakecode.yaml');
  }

  run() async {
    Map config;

    File configFile = File(argResults['config-file']);

    if (await configFile?.exists() == true) {
      log.v("Config file at '${argResults['config-file']}' exists.");

      try {
        var content = await configFile.readAsString();
        config = loadYaml(content);
      } catch (exception) {
        log.e('$exception');
      }
    } else {
      log.w("No config file exists at '${argResults['config-file']}'");
    }

    if (config == null) return;

    if (argResults.wasParsed('config-file')) {
      log.i("Using custom configuration: '${argResults['config-file']}'");
    }

    await Mqtt.init(
      runtimeInstanceID: hashCode.toString(),
      server: config['mqtt']['server'],
      port: config['mqtt']['port'],
      username: config['mqtt']['username'],
      password: config['mqtt']['password'],
    );

    return BakeCode.instance.run();
  }
}

class InitCommand extends Command {
  @override
  String get name => 'init';

  @override
  String get description => """
  Initialize a new BakeCode ecosystem.

  If previously initialised, all the configuration will be purged. 
  """;
}

main(List<String> args) async => CommandRunner("bakecode",
    "BakeCode Ecosystem Kernel. See https://github.com/crysalisdevs/bakecode for more. $args")
  ..addCommand(RunCommand())
  ..addCommand(InitCommand())
  ..run(args);
