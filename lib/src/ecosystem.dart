part of bakecode.engine;

class Ecosystem {
  final Map map;

  @JsonKey(ignore: true)
  File? source;

  Ecosystem({required this.map});

  static Future<Ecosystem> loadFrom([String path = 'config/ecosystem.json']) async {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('$file does not exist.');
    }

    final json = jsonDecode(await file.readAsString());

    if (json is! Map) {
      throw FormatException('Invalid format.', json);
    }

    return Ecosystem(map: json)..source = file;
  }

  static Future<void> saveTo([File? file]) async {}

  Map toJson() => map;
}

// @JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
// class _Service {
//   final String name;

//   final List<_Service> nodes;

//   _Service({
//     required this.name,
//     required this.nodes,
//   }) {
//     if (name.isEmpty) {
//       throw ArgumentError.value(name, 'name', 'Cannot be empty.');
//     }
//   }

//   factory _Service.fromJson(Map<String, dynamic> map) => _$ServiceFromJson(map);

//   Map<String, dynamic> toJson() => _$ServiceToJson(this);

//   @override
//   String toString() => name;
// }
