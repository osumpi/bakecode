part of bakecode.engine;

class Ecosystem {
  final Map map;

  final File source;

  Ecosystem({required this.source, required this.map});

  static const jsonEncoder = JsonEncoder.withIndent('  ');

  static Map<String, dynamic> _convertAddressToMap(
      Iterable<String> levels, String uuid) {
    final map = <String, dynamic>{};

    if (levels.length > 1) {
      map[levels.first] = _convertAddressToMap(levels.skip(1), uuid);
    } else if (levels.length == 1) {
      map[levels.single] = uuid;
    }

    return map;
  }

  Map merge(Address address, String uuid) {
    map.addAll(_convertAddressToMap(address.levels, uuid));
    return map;
  }
  
  static Future<Ecosystem> loadFromFile(
      [String source = 'config/ecosystem.json']) async {
    final file = File(source);

    if (!await file.exists()) {
      stdout.write("""
Ecosystem configuration does not exist at `$source`.
Do you wish to write an example ecosystem? [Y/n]  """);

      var input = stdin.readLineSync()?.substring(0, 1).toLowerCase() ?? '';

      if (input == 'y') {
        await file
            .writeAsString(jsonEncoder.convert(Ecosystem.exampleEcosystem()));
      } else {
        exit(0);
      }
    }

    final json = jsonDecode(await file.readAsString());

    if (json is! Map) {
      throw FormatException('Invalid format.', json);
    }

    return Ecosystem(map: json, source: File(source));
  }

  Future<File> saveToFile([File? file]) =>
      (file ?? source).writeAsString(jsonEncoder.convert(this));

  Map toJson() => map;

  factory Ecosystem.exampleEcosystem() {
    return Ecosystem(
      source: File('config/ecosystem.json'),
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

  @override
  String toString() => jsonEncode(this);
}
