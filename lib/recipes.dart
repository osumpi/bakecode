import 'dart:io';

import 'package:bakecode/compatibility.dart';
import 'package:bakecode/logging.dart';
import 'package:bsi_dart/bsi.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// Contains meta information about recipe.
@immutable
class RecipeMeta {
  /// Name of the recipe.
  final String name;

  /// Provider from where to download the recipe.
  final Uri provider;

  const RecipeMeta({
    required this.name,
    required this.provider,
  });

  /// Make a receipe meta class from provider name instead of it's direct URI.
  factory RecipeMeta.fromProviderName({
    required String name,
    required String author,
    required String providerName,
  }) {
    late Uri uri;

    switch (providerName) {
      case 'github':
        uri = Uri.https('github.com', '$author/$name');
        break;
      case 'bitbucket':
        uri = Uri.https('bitbucket.org', '$author/$name');
        break;
      case 'gitlab':
        uri = Uri.https('gitlab.com', '$author/$name');
        break;
      default:
        // bakecode add recipe choco by someone from https:///somelink.com
        uri = Uri(scheme: providerName);
        break;
    }

    return RecipeMeta(
      name: name,
      provider: uri,
    );
  }

  /// Get the [RecipeMeta] from string [command] which looks like this
  /// ```yaml
  /// recipe_name by author from provider
  /// ```
  factory RecipeMeta.fromString(String command) {
    // <recipe_name> by <author> from <provider>

    final args = command.split(' ');

    try {
      return RecipeMeta.fromProviderName(
        name: args[0],
        author: args[2],
        providerName: args.contains('from') ? args[4] : 'github',
      );
    } catch (e) {
      throw ArgumentError('''
Error in parsing yaml command => $command
Please follow this syntax <recipe_name> by <author> from <provider>
''');
    }
  }
}

/// Manages recipes in bakecode.
class Recipes extends Service {
  Recipes({required File configFile}) : super(configFile);

  Future<bool> get init async => bakeCodeCompatibility.checkGit();

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

  /// Makes a base recipe by passing [name] and [description].
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

  /// Get the recipe by giving [meta] information.
  Future<void> get(RecipeMeta meta) async {
    // Clone in a ".downloaded" folder so that the name is static. This
    // way it's easier to traverse the package to check it's validity.

    var process = await Process.run('git', [
      'clone',
      '${meta.provider}',
      tempGetName,
    ]);

    // stdout.addStream(process.stdout);

    // stderr.addStream(process.stderr);

    if (process.exitCode != 0) {
      log.severe('Oops! Failed to get the receipe. Maybe check the URI?');
      log.severe('Error trace: ${process.stderr}');

      return;
    }

    // Checking if this git project is valid dart package.

    final file = File('$tempGetName/pubspec.yaml');

    if (!await file.exists()) {
      log.severe(
          'Hmm... Pubspec file does not exist! Are you sure that this is a recipe repo?');

      await Directory(tempGetName).delete();

      return;
    }

    // Checking if this git project is valid bakecode recipe package.

    final yaml = loadYaml(await file.readAsString()) as YamlMap;

    // Checking if the pubspec contains the bakecode key in yaml file.

    if (!yaml.containsKey('bakecode')) {
      log.severe(
          'Hmm... Pubspec file does not contain the bakecode key! Are you sure that this is a recipe repo?');

      await Directory(tempGetName).delete();

      return;
    }

    // rename to real recipe name.

    await Directory(tempGetName).rename(yaml['name']);

    // Checking recipes that recipe depends.

    if (yaml['bakecode']['recipe'].containsKey('requires')) {
      for (final receipeCommand in yaml['bakecode']['recipe']['requires']) {
        get(RecipeMeta.fromString(receipeCommand));
      }
    }

    // Get the dart packages.

    Directory.current = Directory(tempGetName);

    await Process.run('dart', ['pub', 'get']);
  }
}
