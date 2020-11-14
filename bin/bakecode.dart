import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode/bakecode.dart';
import 'package:bakecode/src/comms/mqtt/mqtt.dart';
import 'package:meta/meta.dart';
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
    argParser.addOption(
      'config-file',
      abbr: 'c',
      help: "Path to the configuration file",
      defaultsTo: 'bakecode.yaml',
    );
  }

  run() async {
    Map config;

    File configFile = File(argResults['config-file']);

    if (await configFile?.exists() == true) {
      log.v("Config file exists at '${argResults['config-file']}'.");

      try {
        var content = await configFile.readAsString();
        config = loadYaml(content);
      } catch (exception) {
        log.e('$exception');
      }
    } else {
      log.e("No config file exists at '${argResults['config-file']}'");
    }

    if (config == null) return;

    if (argResults.wasParsed('config-file')) {
      log.v("Using custom configuration: '${argResults['config-file']}'");
    }

    await Mqtt().initialize(using: MqttConnection.fromMap(config['MQTT']));

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

class MissingConfigurationException implements Exception {
  final String configurationKey;

  MissingConfigurationException(this.configurationKey);

  @override
  String toString() => "Configuration not found for '$configurationKey'";
}

class ValidateConfigurationCommand extends Command {
  @override
  String get name => 'validate-config';

  @override
  String get description => """
  Configuration file validation tool.

  Validates the specified configuration file.
  """;

  ValidateConfigurationCommand() {
    argParser.addOption(
      'config-file',
      abbr: 'c',
      help: "Path to the configuration file",
      defaultsTo: 'bakecode.yaml',
    );
  }

  Future<bool> run() async {
    Map config;

    File configFile = File(argResults['config-file']);

    if (await configFile?.exists() == true) {
      log.v("Config file exists at '${argResults['config-file']}'.");

      try {
        var content = await configFile.readAsString();
        config = loadYaml(content);
      } catch (exception) {
        log.e('$exception');
      }
    } else {
      log.e("No config file exists at '${argResults['config-file']}'");
    }

    if (config == null) return false;

    if (argResults.wasParsed('config-file')) {
      log.v("Using custom configuration: '${argResults['config-file']}'");
    }

    _validate<Map>(config, 'MQTT');
    _validate<String>(config['MQTT'], 'broker');
    _validate<int>(config['MQTT'], 'port');

    _validate(config, 'BSI');
    _validate<bool>(config['BSI'], 'show pity on BSI packets');
    _validate<bool>(config['BSI'], 'timestamp outgoing packets');
    _validate<bool>(config['BSI'], 'drain outbox on reconnect');

    print(
        'Validation of configuration file at ${configFile.absolute.path} has been completed.');
  }

  void _cfgError(String config, String reason) {
    log.e("""
      Parsing failed for configuration: '$config'.
      Reason: $reason""");
  }

  void _validate<T>(dynamic map, String config, {bool canBeNull = false}) {
    try {
      if ((map as Map).containsKey(config) == false)
        throw MissingConfigurationException(config);

      if (map[config] as T == null && canBeNull == false)
        throw ArgumentError.notNull('');
    } on MissingConfigurationException {
      _cfgError(config, 'Configuration not defined.');
    } on ArgumentError {
      _cfgError(config, 'Value cannot be null.');
    } on TypeError {
      _cfgError(config, "Expected $T; got: ${map[config].runtimeType};");
    } catch (e) {
      _cfgError(config, e);
    }
  }
}

main(List<String> args) async => CommandRunner("bakecode",
    "BakeCode Ecosystem Kernel. See https://github.com/crysalisdevs/bakecode for more.")
  ..addCommand(RunCommand())
  ..addCommand(InitCommand())
  ..addCommand(ValidateConfigurationCommand())
  ..run(args);
