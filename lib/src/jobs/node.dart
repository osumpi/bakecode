import 'package:bakecode/src/jobs/connection.dart';
import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

/// A connectable element.
abstract class Node {
  /// The outbound connection from this node.
  @nonVirtual
  final output = Connection();

  /// Connects the instance node to the specified [node].
  ///
  /// For `A` as the instance node and `B` as the specified [node],
  /// ```dart
  /// A.connect(B);
  /// ```
  /// makes a new **forward connection** from `A` to `B`, such that `B` listens
  /// to `A`'s [output] connection.
  ///
  /// To make a forward conection to multiple nodes, use [connectToAll].
  @nonVirtual
  void connectTo(Node node) => output.addEndPoint(node);

  /// Connects the instance node to every [Node] in [nodes].
  ///
  /// For `A` as the instance node and `B` as a Node in [nodes],
  /// ```dart
  /// A.connect(B);
  /// ```
  /// makes a new **forward connection** from `A` to `B`, such that `B` listens
  /// to `A`'s [output] connection.
  ///
  /// To make a forward conection to a single node, use [connectTo].
  @nonVirtual
  void connectToAll(List<Node> nodes) => nodes.map(connectTo);

  Future<FlowContext> run(FlowContext context);
}
