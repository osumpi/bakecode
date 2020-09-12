import 'dart:io';

import 'package:bakecode/framework/context.dart';
import 'package:bakecode/framework/logger.dart';
import 'package:bakecode/framework/mqtt.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

export 'package:bakecode/framework/context.dart';
// export 'package:bakecode/framework/quantities.dart';
// export 'package:bakecode/framework/actions.dart';

class BakeCode {
  /// Factory redirecting to [BakeCode.instance].
  factory BakeCode() => instance;

  /// Instance of Singleton [BakeCode].
  static final instance = BakeCode._();

  /// Private generative constructor.
  const BakeCode._();

  /// Provides a context for every sub-services of [BakeCode].
  Context get context => Context.root('bakecode');

  void publish(String message) =>
      MqttRuntime.instance.publish(topic: context.path, message: message);

  //Stream get stream;
}

/// [BakeCodeRuntime] singleton service.
/// The root of the kernel.
///
/// Holds the following:
/// * Runtime instance.
/// * MQTT client (kernel) instance.
/// * GetIt instance for global data accessing.
@sealed
class BakeCodeRuntime extends BakeCode {
  /// Generative constructor.
  BakeCodeRuntime._() : super._();

  /// Instance of [BakeCodeRuntime].
  static final BakeCodeRuntime instance = BakeCodeRuntime._();

  /// Factory constructor redirecting to [BakeCodeRuntime.instance]
  factory BakeCodeRuntime() => instance;

  @override
  Context get context => super.context.child('runtime').child('$hashCode');

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

  void _init() async {
    log.i('Starting BakeCode Runtime ($hashCode)...');

    config = await _getConfig(fromPath: 'bakecode.yaml');

    MqttRuntime.instance.init(
      runtimeInstanceID: hashCode.toString(),
      server: config['mqtt']['server'],
      port: config['mqtt']['port'],
      username: config['mqtt']['username'],
      password: config['mqtt']['password'],
    );
  }

  void run() => _init();
}

// /// [BakeCodeService] abstract layer.
// abstract class BakeCodeService {
//   /// [BakeCodeRuntime] service instance.
//   BakeCodeRuntime get runtime => BakeCodeRuntime.instance;

//   /// [ServicePath] of [this] [BakeCodeService].
//   ServicePath get servicePath => runtime.servicePath;

//   /// The default constructor for [BakeCodeService] binds all the necessary
//   /// runtime services required by a [BakeCodeService].
//   ///
//   /// **Includes:**
//   ///
//   /// * `onMessage` an overridable Function(String) listens to subscriptions
//   /// for this service.
//   ///
//   /// * `publish(String message)` facilitates publishing of message to this
//   /// service's channel.
//   ///
//   BakeCodeService() {
//     /// Subscribes and implements callbacks for using mqtt service.
//     runtime.mqtt.addSubscription(servicePath.path, onMessage: onMessage);
//   }

//   /// [onMessage] callback abstract implementation.
//   /// Override and implement the handler.
//   void onMessage(String message);

//   /// Publish a [message] on [this] [BakeCodeService].
//   void publish(String messsage) =>
//       runtime.mqtt.publishMessage(topic: servicePath.path, message: messsage);
// }

// /// A collection group of [BakeCodeService]s as a [BakeCodeService].
// abstract class BakeCodeServiceCollection<T> extends BakeCodeService {
//   /// All the sub-services in [this] collection.
//   final List<T> services = [];
// }

// abstract class Hardware extends BakeCodeService {
//   bool isOnline = false;
//   bool isBusy = false;

//   String get name;

//   Future<String> getName();
//   Future<String> getVersion();
// }

// /// [Tool] abstact layer.
// abstract class Tool extends BakeCodeService {
//   bool isOnline = false;
//   bool isBusy = false;

//   /// returns the name of the [Tool].
//   String get name;

//   /// [Tool] default constructor adds [this] to [ToolsCollection.tools].
//   Tool() {
//     ToolsCollection.instance.tools.add(this);
//   }

//   /// returns the current sessionID of the [Tool].
//   /// [sessionID] relies on the object's [hashCode].
//   String get sessionID => hashCode.toString();

//   /// [ServicePath] to this tool instance.
//   @override
//   ServicePath get servicePath =>
//       ToolsCollection().servicePath.child(name).child(sessionID);
// }
