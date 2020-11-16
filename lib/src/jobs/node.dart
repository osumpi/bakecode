import 'package:bakecode/src/jobs/connection.dart';
import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

/// A connectable element with multiple inputs and single output.
abstract class Node {
  /// All inbound connections to this node.
  @nonVirtual
  final inputs = <Connection>[];

  /// The outbound connection from this node.
  @nonVirtual
  final output = Connection();

  /// Connects the instance node to the specified [to] node.
  ///
  /// For `A` as the instance node and `B` as the specified [to] node,
  /// ```dart
  /// A.connect(B);
  /// ```
  /// makes a new **forward connection** from `A` to `B`, such that `A`'s
  /// [output] is added to `B`'s [input].
  ///
  /// `A` --> `B`
  ///
  /// To make a forward conection to multiple nodes, use [connectToAll].
  @nonVirtual
  void connectTo(Node to) => to.inputs.add(output);

  /// Makes a forward connection from this node to all [nodes].
  void connectToAll(List<Node> nodes) => nodes.map(connectTo);
}
