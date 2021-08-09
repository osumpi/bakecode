import 'dart:io';

import 'package:bakecode_engine/compatibility.dart';
import 'package:core/core.dart';

/// Manages recipes in bakecode.
class Recipes extends Service {
  Recipes._();

  @override
  String get name => 'Recipe Manager';

  @override
  Address get address => Address('bakecode/recipes');

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

dev_dependencies:
''';

  /// Makes a base bakecode recipe.
  Future<void> make(String name, String description) async {
    for (final filename in _packageTemplateFiles) {
      final file = File(filename);
      await file.create(recursive: true);
      if (filename == 'pubspec.yaml') {
        await file.writeAsString(_makePubspec(name, description));
      }
    }
  }

  Future<void> get(Uri gitUri) async {

  }
}

final recipes = Recipes._();

Future<void> main(List<String> args) async {
  print(await recipes.init());
}
