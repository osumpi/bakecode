import 'package:meta/meta.dart';

@immutable
class NodeReference {
  final String _id;

  static const _useHashCode = '#use_hashCode';

  String get id => _id == _useHashCode ? '$hashCode' : _id;

  const NodeReference._(this._id);

  factory NodeReference.create() => NodeReference._(_useHashCode);

  factory NodeReference.fromID(String id) => NodeReference._(id);

  toString() => 'NodeReference: $_id';
}
