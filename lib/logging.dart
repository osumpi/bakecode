import 'dart:io';

import 'package:console/console.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

final log = Logger('bakecode');

void initialize() {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    if (record.level == Level.CONFIG) {
      Console.setTextColor(Color.CYAN.id);
      stdout.write(record.message);
      Console.resetAll();
    } else {
      Console.setTextColor(Color.WHITE.id, bright: true);
      Console.setBackgroundColor(Color.CYAN.id, bright: true);
      stdout.write(' ${DateFormat('MMM d hh:mm:ss').format(record.time)} ');

      Console.setTextColor(Color.WHITE.id, bright: true);
      Console.setBackgroundColor(Color.MAGENTA.id, bright: true);
      stdout.write(' ${record.loggerName} ');

      if (record.level == Level.FINE) {
        Console.setTextColor(Color.WHITE.id, bright: true);
        Console.setBackgroundColor(Color.LIME.id, bright: true);
        stdout.write(' ✓ ');
        Console.resetBackgroundColor();
        Console.setTextColor(Color.LIME.id, bright: true);
      }
      else if (record.level == Level.FINEST) {
        Console.setTextColor(Color.LIME.id, bright: true);
      }
      else if (record.level == Level.WARNING) {
        Console.setTextColor(Color.WHITE.id, bright: true);
        Console.setBackgroundColor(Color.YELLOW.id, bright: true);
        stdout.write(' ! ');
        Console.resetBackgroundColor();
        Console.setTextColor(Color.YELLOW.id, bright: true);
      } else if (record.level == Level.SEVERE) {
        Console.setTextColor(Color.WHITE.id, bright: true);
        Console.setBackgroundColor(Color.RED.id, bright: true);
        stdout.write(' ✗ ');
        Console.resetBackgroundColor();
        Console.setTextColor(Color.RED.id, bright: true);
      }

      stdout.writeln(' ${record.message}');
      Console.resetAll();
    }
  });
}
