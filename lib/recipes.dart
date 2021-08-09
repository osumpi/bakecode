import 'dart:io';

import 'package:bakecode_engine/compatibility.dart';
import 'package:bakecode_engine/logging.dart';
import 'package:core/core.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

/// Manages recipes in bakecode.
class Recipes extends Service {
  Recipes._()
      : super(
          id: UuidValue('296afb91-547e-45e8-a368-1b61542ad5ce'),
          name: 'Recipe Manager',
        );

  Future<bool> init() async => bakeCodeCompatibility.checkGit();

  /// Template file name for bakecode receipe package.
  static const _packageTemplateFiles = [
    'lib/main.dart',
    'README.md',
    '.gitignore',
    'pubspec.yaml',
  ];

  /// Generate pubspec for bakecode receipe package.
  String _makePubspec(String name, String description) => '''
name: $name

description: $description

version: 0.0.1-alpha

publish_to: none

environment:
  sdk: '>=2.13.0 <3.0.0'

dependencies:
  args: latest
  core:
    git: git@github.com:bakecode-devs/core.git

''';

  /// Makes a base recipe.
  Future<void> make(String name, String description) async {
    for (final filename in _packageTemplateFiles) {
      final file = File(filename);

      await file.create(recursive: true);

      if (filename == 'pubspec.yaml') {
        await file.writeAsString(_makePubspec(name, description));
      }
    }
  }

  static const tempGetName = '.downloaded';

  /// Get the recipe.
  Future<void> get(Uri uri) async {
    // Clone in a ".downloaded" folder so that the name is static. This
    // way it's easier to traverse the package to check it's validity.

    var process = await Process.run('git', [
      'clone',
      '$uri',
      tempGetName,
    ]);

    if (process.exitCode != 0) {
      log('Oops! Failed to get the receipe. Maybe check the URI?');
      log('Error trace: ${process.stderr}');
    }

    // Checking if this git project is valid dart package.

    final file = File('$tempGetName/pubspec.yaml');

    if (!await file.exists()) {
      log('Hmm... Pubspec file does not exist! Are you sure that this is a recipe repo?');

      await Directory(tempGetName).delete();

      return;
    }

    // Checking if this git project is valid bakecode recipe package.

    final yaml = loadYaml(await file.readAsString()) as YamlMap;

    // Checking if the pubspec contains the bakecode key in yaml file.

    if (!yaml.containsKey('bakecode')) {
      log('Hmm... Pubspec file does not contain the bakecode key! Are you sure that this is a recipe repo?');

      await Directory(tempGetName).delete();

      return;
    }

    // Checking recipes that recipe depends.

    if (yaml.containsKey('recipes')) {}

    // Get the dart packages.

    Directory.current = Directory(tempGetName);

    await Process.run('dart', ['pub', 'get']);
  }
}

final recipes = Recipes._();

Future<void> main(List<String> args) async {
  print(await recipes.init());
}
