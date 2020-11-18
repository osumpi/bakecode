import 'package:bakecode/bakecode.dart';
import 'package:meta/meta.dart';

abstract class States {
  ServiceReference get reference;

  void notify(ServiceReference to, {@required String message});

  @nonVirtual
  ServiceReference get state => reference.child('state');

  void updateState(String stateName, String value) =>
      notify(state.child(stateName), message: value);

  String get name => reference.name;
}

class State<T> {
  final String identifier;

  T value;

  toString() => """
  {
    "state": "$identifier",
    
  }
  """;
}
