import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:mycli/kirby/kirby_menu.dart';

void mainMenu() {
  'clear'.run;
  print('''
#################################
### My CLI projects generator ###
#################################
''');

  const List<String> options = [
    'Kirby',
    'Flutter',
    'Dart\n',
    'Exit',
  ];

  final String selected = menu('\nSelect project:', options: options);

  if (selected == options[0]) kirbyMenu();
  if (selected == options[1]) print('Flutter selected');
  if (selected == options[2]) print('Dart selected');

  if (selected == options.last) {
    print('\nBye!');
    exit(0);
  }
}
