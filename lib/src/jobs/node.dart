import 'dart:async';

import 'package:bakecode/src/jobs/connection.dart';
import 'package:bakecode/src/jobs/jobs.dart';
import 'package:meta/meta.dart';

// TODO: add progress awaition for flowcontext specials... make use of listen.onDone callback
/// A connectable element.
abstract class Node {
  /// Contains the received [FlowContext] for every [InputConnection] connected
  /// to the instance [Node].
  ///
  /// [inputContexts.values] can contain null if a [FlowContext] was not
  /// received from an [InputConnection] in [inputs].
  final inputContexts = <InputConnection, FlowContext>{};

  /// Every [InputConnection]s the [Node] listens to.
  Iterable<InputConnection> get inputs => inputContexts.keys;

  /// The [OutputConnection] of this instance [Node].
  ///
  /// [Connection] closes once [run] has successfully completed.
  final OutputConnection output = Connection();

  /// Evaluates to true if received a [FlowContext] from every [inputs] of the
  /// instance node else false.
  ///
  /// Checks if [inputContexts.values] contains null. [inputContexts.values]
  /// is null if a [FlowContext] was not received from an [InputConnection] in
  /// [inputs].
  bool get receivedAll => inputContexts.values.contains(null) == false;

  /// Start's listening to [input] for [FlowContext].
  void await(InputConnection input) {
    inputContexts[input] = null;

    input.stream.listen((context) async {
      inputContexts[input] = context;

      if (receivedAll) {
        output.sink
          ..add(await run(context))
          ..close();
        // TODO: merge contextsss of every first elements
      }
    });
  }

  /// Connects the instance node to the specified [node].
  ///
  /// For `A` as the instance node and `B` as the specified [node],
  /// ```dart
  /// A.connectTo(B);
  /// ```
  /// makes a new **forward connection** from `A` to `B`, such that `B` listens
  /// to `A`'s [output] connection.
  ///
  /// To make a forward conection to multiple nodes, use [connectToAll].
  @nonVirtual
  void connectTo(Node node) => output.sink;

  /// Connects the instance node to every [Node] in [nodes].
  ///
  /// For `A` as the instance node and [nodes] as a collection of [Node]s,
  /// ```dart
  /// A.connectToAll(nodes);
  /// ```
  /// makes a new **forward connection** from `A` to every node in [nodes],
  /// such that every [Node] in [nodes] listens to `A`'s [output] connection.
  ///
  /// To make a forward conection to a single node, use [connectTo].
  @nonVirtual
  void connectToAll(List<Node> nodes) => nodes.map(connectTo);

  /// Executed when all inputs gives a
  @protected
  Future<FlowContext> run(FlowContext context);
}
