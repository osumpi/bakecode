part of bakecode.engine;

class Ecosystem {
  final Map map;

  final String source;

  Ecosystem({required this.source, required this.map});

  static const jsonEncoder = JsonEncoder.withIndent('  ');

  static Future<Ecosystem> loadFrom([String source = 'config/ecosystem.json']) async {
    final file = File(source);

    if (!await file.exists()) {
      stdout.write("""
Ecosystem configuration does not exist at `$source`.
Do you wish to write an example ecosystem? [Y/n]  """);

      var input = stdin.readLineSync()?.substring(0, 1).toLowerCase() ?? '';

      if (input == 'y') {
        await file.writeAsString(jsonEncoder.convert(Ecosystem.exampleEcosystem()));
      }
    }

    final json = jsonDecode(await file.readAsString());

    if (json is! Map) {
      throw FormatException('Invalid format.', json);
    }

    return Ecosystem(map: json, source: source);
  }

  factory Ecosystem.exampleEcosystem() {
    return Ecosystem(
      source: 'config/ecosystem.json',
      map: {
        "bakecode": {
          "kitchen": {
            "storage": {
              "icy-resurrection": {},
            }
          },
          "dine-in": {
            "family-dine-in": {},
            "open-dine-in": {},
          },
          "dine-out": {},
        }
      },
    );
  }

  Future<void> saveTo([File? file]) async {}

  Map toJson() => map;
}
