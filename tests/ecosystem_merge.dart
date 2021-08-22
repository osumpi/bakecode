import 'dart:convert';

import 'package:bakecode_engine/bakecode.dart';
import 'package:core/core.dart';

const config = '''
{
    "bakecode": {
      "kitchen": {
        "storage": {
          "icy-resurrection": {}
        }
      },
      "dine-in": {
        "family-dine-in": {},
        "open-dine-in": {}
      },
      "dine-out": {}
    },
}
''';

const processedConfig = '''
{
  "bakecode": {
    "kitchen": {
      "storage": {
        "icy-resurrection": {}
      }
    },
    "dine-in": {
      "family-dine-in": {},
      "open-dine-in": {}
    },
    "dine-out": {}
  },
  "something": {
    "inside": {
      "led": "ea3b800f-f148-41ff-b558-e4807f13ce63"
    }
  }
}
''';

Future<bool> testEcosystem() async {
  final ecosystem = await Ecosystem.loadFromFile();

  ecosystem.addService(
      Address('something/inside/led'), 'ea3b800f-f148-41ff-b558-e4807f13ce63');

  return const JsonEncoder.withIndent('  ').convert(ecosystem) ==
      processedConfig;
}
