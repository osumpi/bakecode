import 'dart:io';

import 'package:bakecode_engine/logging.dart';

/// Handles compatibility for bakecode.
class BakeCodeCompatibility {
  const BakeCodeCompatibility._();

  /// Checks if a command can be [executable] with [arguments] and [errorMsg]
  /// if the command fails.
  Future<bool> _check(
      String executable, List<String> arguments, String errorMsg) async {
    try {
      await Process.run(executable, arguments);
    } on ProcessException {
      log(errorMsg);
      return false;
    }
    return true;
  }

  /// Checks if git is available in the system.
  Future<bool> checkGit() async =>
      _check('git', ['--version'], 'git is not installed. Please install it!');

  /// Checks if dart is available in the system.
  Future<bool> checkDart() async => _check(
      'dart', ['--version'], 'dart is not installed. Please install it!');

  /// Checks if curl is available in the system.
  Future<bool> checkCurl() async => _check(
      'curl', ['--version'], 'curl is not installed. Please install it!');

  Future<bool> init() async {
    return ![
      await checkGit(),
      await checkCurl(),
      await checkDart(),
    ].any((checks) => false);
  }
}

const bakeCodeCompatibility = BakeCodeCompatibility._();
