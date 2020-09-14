import 'dart:io';

import 'package:bakecode/framework/context.dart';
import 'package:bakecode/framework/logger.dart';
import 'package:bakecode/framework/mqtt.dart';
import 'package:bakecode/framework/service.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

class BakeCode extends BakeCodeService {
  BakeCode._() {
    onMessage.listen(print);
  }

  static final instance = BakeCode._();

  factory BakeCode() => instance;

  @override
  Context get context => Context.root('bakecode');
}

/// [BakeCodeRuntime] singleton service.
/// The root of the kernel.
///
/// Holds the following:
/// * Runtime instance.
/// * MQTT client (kernel) instance.
/// * GetIt instance for global data accessing.
@sealed
class BakeCodeRuntime extends BakeCodeService {
  /// Generative constructor.
  BakeCodeRuntime._() {
    onMessage.listen(print);
  }

  /// Instance of [BakeCodeRuntime].
  static final BakeCodeRuntime instance = BakeCodeRuntime._();

  /// Factory constructor redirecting to [BakeCodeRuntime.instance]
  factory BakeCodeRuntime() => instance;

  @override
  Context get context => BakeCode().context.child('runtime').child('$hashCode');

  Map config;

  Future<Map> _getConfig({@required String fromPath}) async {
    File configFile = File(fromPath);

    if ((await configFile?.exists() == true)) {
      log.d("Getting config from '$fromPath'");
      try {
        String content = await configFile.readAsString();
        return loadYaml(content);
      } catch (exception) {
        log.e(exception.toString());
      }
    } else {
      log.w('$fromPath does not exist!');
    }

    return null;
  }

  Future _init() async {
    await log.i('Starting BakeCode Runtime ($hashCode)...');

    config = await _getConfig(fromPath: 'bakecode.yaml');

    await Mqtt.init(
      runtimeInstanceID: hashCode.toString(),
      server: config['mqtt']['server'],
      port: config['mqtt']['port'],
      username: config['mqtt']['username'],
      password: config['mqtt']['password'],
    );
  }

  Future run() async => await _init();
}
