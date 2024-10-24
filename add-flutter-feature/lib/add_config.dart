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
  print(cyan('Adding packages...'));
  'dart pub add dio'.start(detached: true);
  'dart pub add envied'.start(detached: true);

  // copy files
  final configFolderFrom = p.relative('lib/_skeleton');
  copyTree(configFolderFrom, p.relative('./'));

  print(green('Config files created successfully'));
}
