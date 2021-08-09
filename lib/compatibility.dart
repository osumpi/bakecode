import 'dart:io';

import 'package:bakecode_engine/logging.dart';

/// Handles compatibility for bakecode.
class BakeCodeCompatibility {
  const BakeCodeCompatibility._();

  /// Checks if git is available in the system.
  Future<bool> checkGit() async {
    try {
      await Process.run('git', ['--version']);
    } on ProcessException {
      log('git is not installed. Please install it');
      return false;
    }
    return true;
  }

  Future<bool> init() async {
    return ![await checkGit()].any((checks) => false);
  }
}

const bakeCodeCompatibility = BakeCodeCompatibility._();
