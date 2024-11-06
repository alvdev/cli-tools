import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as p;

void addConfigFiles() {
  if (exists('lib/config')) {
    print(magenta('Config folder already exists'));
    exit(0);
  }

  if (exists('analysis_options.yaml')) {
    print(blue('analysis_options.yaml already exists. Backup created'));
    move('analysis_options.yaml', 'analysis_options.yaml.bak', overwrite: true);
  }

  // add dependencies
  print(blue('Adding packages...'));

  'dart pub add dio'.start(detached: true);
  print(cyan('\t-> Added Dio package'));

  'dart pub add envied'.start(detached: true);
  print(cyan('\t-> Added Envied package'));

  'dart pub add flutter_localizations --sdk=flutter'.start(detached: true);
  'dart pub add intl'.start(detached: true);
  print(cyan('\t-> Added Internationalization packages'));

  'dart pub add go_router'.start(detached: true);
  print(cyan('\t-> Added Go Router package'));

  'dart pub add flutter_svg'.start(detached: true);
  print(cyan('\t-> Added Flutter SVG package'));

  'dart pub add freezed_annotation'.start(detached: true);
  'dart pub add dev:build_runner'.start(detached: true);
  'dart pub add dev:freezed'.start(detached: true);
  'dart pub add add json_annotation'.start(detached: true);
  'dart pub add dev:json_serializable'.start(detached: true);
  print(cyan('\t-> Added Freezed packages'));

  // copy files
  final configFolderFrom = p.relative('lib/_skeleton');
  copyTree(configFolderFrom, p.relative('./'));

  print(green('Config files created successfully'));
}
