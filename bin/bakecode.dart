import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode_engine/bakecode.dart' as bakecode;
import 'package:core/core.dart';
import 'package:hotreloader/hotreloader.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner('bakecode', bakecode.description);

  runner.argParser
    ..addFlag(
      'version',
      negatable: false,
      help: 'Prints the bakecode engine version.',
      callback: (wasParsed) {
        if (wasParsed) print('bakecode-engine <version>');
      },
    );

  // TODO: Check existence of LICENSE.
  if (await File('LICENSE').exists() == false) {
    // print("LICENSE not found. Will not run.");

    // return 0x01; // TODO: uncomment this
  }
  // TODO: Check T&C agreement.

  const config = BSIConfiguration(
    clientIdentifier: 'bakecode-engine',
    server: '192.168.43.20',
    port: 1883,
    username: 'user',
    password: 'iL0v3MoonGaYoung',
  );

  print(await BSI.instance.initialize(config: config));

  final ecosystem = await bakecode.Ecosystem.loadFrom();
}
