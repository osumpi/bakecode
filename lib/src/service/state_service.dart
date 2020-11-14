import 'package:bakecode/bakecode.dart';
import 'package:meta/meta.dart';

import 'service.dart';

@sealed
class StateService implements Service {
  final reference;

  StateService(String name, {@required Service of})
      : assert(name != null),
        assert(of != null),
        reference = of.state.child(name);

  String get name => reference.name;

  get state => reference.parent;

  broadcast(String message) => throw UnsupportedError(
      "$runtimeType's are not allowed to broadcast messages.");

  notify(ServiceReference to, {String message}) => throw UnsupportedError(
      "$runtimeType's are not allowed to send messages.");

  get onReceive => throw UnsupportedError(
      "$runtimeType's are not allowed to receive messages");

  void update({@required String state}) => BSI().outbox.add(ServiceMessage(
      source: reference, destinations: [reference], message: state));
}
