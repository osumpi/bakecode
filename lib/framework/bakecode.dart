// import 'package:bakecode/framework/actions.dart';
// import 'package:bakecode/framework/mqtt.dart';
// import 'package:bakecode/framework/quantities.dart';
import 'package:bakecode/framework/context.dart';
import 'package:get_it/get_it.dart';
// import 'package:meta/meta.dart';

export 'package:bakecode/framework/context.dart';
// export 'package:bakecode/framework/quantities.dart';
// export 'package:bakecode/framework/actions.dart';


abstract class BakeCode {
  Context get context => Context.root('bakecode');
}

/// [BakeCodeRuntime] singleton service.
/// The root of the kernel.
///
/// Holds the following:
/// * Runtime instance.
/// * MQTT client (kernel) instance.
/// * GetIt instance for global data accessing.
class BakeCodeRuntime extends BakeCode {
  BakeCodeRuntime._();

  /// [BakeCodeRuntime] singleton service instance.
  static BakeCodeRuntime instance = BakeCodeRuntime._();

  /// [MqttRuntime] service instance.
  // final mqtt = MqttRuntime.instance;

  /// [GetIt] service instance.
  final getIt = GetIt.instance;

  @override
  Context get context => super.context.child('runtime').child('$hashCode');

  void run() {
    print('BakeCodeRuntime kernel- started at: $context');
    while (true);
  }
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
