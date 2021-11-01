part of bakecode.engine;

class RecipesCommand extends Command {
  @override
  String get name => 'recipes';

  @override
  String get description => """
Recipe manager.
This requires the recipe manager service running in the ecosystem.
""";

  @override
  void run() {
    // ignore: avoid_print
    print(argResults!.arguments);
  }
}
