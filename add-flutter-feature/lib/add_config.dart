import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

void addConfigFiles() {
  if (exists('lib/config')) {
    print(magenta('Config folder already exists'));
    exit(0);
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

  'dart pub add flutter_riverpod'.start(detached: true);
  print(cyan('\t-> Added Flutter Riverpod package'));

  'dart pub add flutter_svg'.start(detached: true);
  print(cyan('\t-> Added Flutter SVG package'));

  'dart pub add freezed_annotation'.start(detached: true);
  'dart pub add dev:build_runner'.start(detached: true);
  'dart pub add dev:freezed'.start(detached: true);
  'dart pub add add json_annotation'.start(detached: true);
  'dart pub add dev:json_serializable'.start(detached: true);
  print(cyan('\t-> Added Freezed packages'));

  // copy skeleton files
  final exeBaseDir = File(Platform.script.toFilePath()).parent.parent.path;
  final skeletonDir = '$exeBaseDir/lib/_skeleton/';
  final skeletonRootFiles = find(
    '*',
    workingDirectory: skeletonDir,
    recursive: false,
  ).toList();

  for (final f in skeletonRootFiles) {
    if (exists(basename(f))) {
      print(blue('${basename(f)} exists. Backup file created.'));
      move(basename(f), '${basename(f)}.bak', overwrite: true);
    }

    print(magenta('Copying ${basename(f)}'));
    copy(f, relative('./'), overwrite: true);
  }

  copyTree(
    '$skeletonDir/lib/',
    relative('lib/'),
    overwrite: true,
    filter: (f) => !f.contains('/features/'),
  );

  print(green('Config files created successfully'));
}
