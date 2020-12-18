import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode_ecosystem_runtime/bakecode_ecosystem_runtime.dart';
import 'package:bakecode_ecosystem_runtime/logger.dart';
import 'package:bsi/bsi.dart';

Future<void> main(List<String> args) async {
  // Check existence of LICENSE.
  if (await File('LICENSE').exists() == false) {
    print("LICENSE not found. Won't run.");

    // return 0x01; // TODO: uncomment this
  }
  // Check T&C agreement.

  CommandRunner(
    'bakecode',
    """
BakeCode Ecosystem Kernel. See https://github.com/crysalisdevs/bakecode for more.

Copyright (C) 2020, the BakeCode project authors.
This program comes with ABSOLUTELY NO WARRANTY; for details type 'show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type 'show c' for details.
    """,
  )
    ..addCommand(ShowCommand())
    ..addCommand(RunCommand())
    ..addCommand(ConfigCommand())
    ..addCommand(InitCommand())
    ..run(args);
}

class ShowCommand extends Command {
  @override
  String get name => 'show';

  @override
  String get description => """
  Shows information related to BakeCode Ecosystem and the BakeCode Ecosystem Kernel.
  """;

  bool showWarranty = false;
  bool showConditions = false;
  bool showLicense = false;

  ShowCommand() {
    argParser.addFlag(
      'warranty',
      abbr: 'w',
      help:
          "Shows the warranty statement of the BakeCode project as stated in the LICENSE.",
      callback: (value) => showWarranty = value ?? false,
    );

    argParser.addFlag(
      'conditions',
      abbr: 'c',
      help:
          "Shows the conditions for redistribution of the BakeCode project as stated in the LICENSE.",
      callback: (value) => showConditions = value ?? false,
    );

    argParser.addFlag(
      'license',
      help: "Shows the LICENSE.",
      callback: (value) => showLicense = value ?? false,
    );
  }

  run() {
    if (showWarranty) print("""
  15. Disclaimer of Warranty.

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.""");

    // TODO: conditions to be printed after merging new license.
    if (showConditions) print("""
  """);
  }
}

class RunCommand extends Command {
  @override
  String get name => 'run';

  @override
  List<String> get aliases => ['start', 'launch'];

  @override
  String get description => """
  Run the BakeCode Ecosystem.
  """;

  @override
  FutureOr<void> run() async {
    Map config;

    final configFile = File('config.json');

    if (await configFile?.exists() == true) {
      try {
        var content = await configFile.readAsString();
        config = jsonDecode(content);
      } catch (e) {
        print("""
        Couldn't read ${configFile.absolute.path}.

        Reason:
        $e
        """);
      }
    } else {
      log.e("Config file does not exist at ${configFile.absolute.path}");
    }

    if (config == null) return;

    await Mqtt().initialize(
      using: BSIConfiguration.from(
        representingService: BakeCode.instance.reference,
        broker: config['mqtt-broker'],
        port: config['mqtt-port'],
        auth_username: config['mqtt-username'],
        auth_password: config['mqtt-key'],
      ),
    );

    return BakeCode.instance.run();
  }
}

class ConfigCommand extends Command {
  @override
  String get name => 'config';

  @override
  String get description => """
  Configure BakeCode Ecosystem Settings.

  To remove a setting, configure it to an empty string.
  """;

  final specifiedConfig = <String, dynamic>{};

  bool showConfig = false;

  ConfigCommand() {
    argParser.addFlag(
      'show',
      help: "Shows the configurations",
      callback: (value) => showConfig = value,
    );

    argParser.addOption(
      'mqtt-broker',
      help: "The address of MQTT broker.",
      valueHelp: 'address',
      callback: (value) => specifiedConfig['mqtt-broker'] = value,
    );

    argParser.addOption(
      'mqtt-port',
      help: "The port number at which MQTT broker instance is running.",
      valueHelp: 'port number',
      callback: (value) =>
          specifiedConfig['mqtt-port'] = int.tryParse(value ?? ''),
    );

    argParser.addOption(
      'mqtt-username',
      help: "The username to be used to authenticate w/ the MQTT broker.",
      callback: (value) => specifiedConfig['mqtt-username'] = value,
    );

    argParser.addOption(
      'mqtt-key',
      help: "The password/key to be to authenticate w/ the MQTT broker.",
      callback: (value) => specifiedConfig['mqtt-key'] = value,
    );
  }

  run() async {
    Map config = {};

    File configFile = File('config.json');

    if (await configFile?.exists() == true) {
      try {
        config.addAll(jsonDecode(await configFile.readAsString()));
      } catch (e) {
        print("""
        Failed to load config.json properly.

        Reason: 
        $e

        Possible solutions:
        * Make sure only one Yaml document is present.
        * Try deleting config.json and running bakecode init to create a fresh one.
        """);
      }
    } else {
      print("Creating config.json...");

      try {
        await configFile.create();
      } on FileSystemException catch (e) {
        print("""
        Failed to create config.json.

        Reason: 
        $e
        """);
      }
    }

    if (config == null) return;

    if (specifiedConfig.keys.isEmpty == false) {
      specifiedConfig.removeWhere((key, value) => value == null);

      config.addAll(specifiedConfig);

      var encoder = JsonEncoder.withIndent('    ');
      try {
        await configFile.writeAsString(encoder.convert(config));
      } catch (e) {
        print("""
        Failed to write new configurations.
        
        Reason:
        $e""");
      }
    }
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
