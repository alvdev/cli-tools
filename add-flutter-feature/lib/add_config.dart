import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:yaml_edit/yaml_edit.dart';

void addConfigFiles() {
  if (exists('lib/config')) {
    print(magenta('Config folder already exists'));
    exit(0);
  }

  // copy skeleton files
  final exeBaseDir = File(Platform.script.toFilePath()).parent.parent.path;
  final skeletonDir = '$exeBaseDir/lib/_skeleton/';
  final skeletonRootFiles = find(
    '*',
    workingDirectory: skeletonDir,
    recursive: false,
  ).toList();

  print(white('\n⯀\n⯀ Copying files...\n⯀'));
  for (final f in skeletonRootFiles) {
    if (exists(basename(f))) {
      print(blue('⯀\n⯀ ${basename(f)} exists. Backup file created.'));
      move(basename(f), '${basename(f)}.bak', overwrite: true);
    }

    print(green('⯀ ${basename(f)} created', bold: false));
    copy(f, relative('./'), overwrite: true);
  }

  copyTree(
    '$skeletonDir/lib/',
    relative('lib/'),
    overwrite: true,
    filter: (f) => !f.contains('/features/'),
  );

  // edit pubspec.yaml before adding packages.Otherwise it will fail
  editYaml();

  // Add dependencies after copying skeleton. Otherwise it will fail
  print(white('\n⯀\n⯀ Adding packages...\n⯀'));

  try {
    'flutter pub add dio'.start();
    print(green('⯀ Added Dio package', bold: false));
  } catch (e) {
    print(red('⯀ Failed to add Dio package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add envied'.start(progress: Progress.devNull());
    print(green('⯀ Added Envied package', bold: false));
  } catch (e) {
    print(red('⯀ Failed to add Envied package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add flutter_localizations --sdk=flutter'
        .start(progress: Progress.devNull());
    'flutter pub add intl'.start(progress: Progress.devNull());
    print(green('⯀ Added Internationalization packages', bold: false));
  } catch (e) {
    print(red(
        '⯀ Failed to add Internationalization packages: ${e.errorMessage}'));
  }

  try {
    'flutter pub add go_router'.start(progress: Progress.devNull());
    print(green('⯀ Added Go Router package', bold: false));
  } catch (e) {
    print(red('⯀ Failed to add Go Router package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add flutter_riverpod'.start(progress: Progress.devNull());
    print(green('⯀ Added Flutter Riverpod package', bold: false));
  } catch (e) {
    print(red('⯀ Failed to add Flutter Riverpod package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add flutter_svg'.start(progress: Progress.devNull());
    print(green('⯀ Added Flutter SVG package', bold: false));
  } catch (e) {
    print(red('⯀ Failed to add Flutter SVG package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add freezed_annotation'.start(progress: Progress.devNull());
    'flutter pub add dev:build_runner'.start(progress: Progress.devNull());
    'flutter pub add dev:freezed'.start(progress: Progress.devNull());
    'flutter pub add json_annotation'.start(progress: Progress.devNull());
    'flutter pub add dev:json_serializable'.start(progress: Progress.devNull());
    print(green('⯀ Added Freezed packages', bold: false));
  } catch (e) {
    print(red('⯀ Failed to add Freezed packages: ${e.errorMessage}'));
  }

  try {
    'dart run build_runner build'.start(progress: Progress.devNull());
    print(green('⯀ Built Freezed classes', bold: false));
  } catch (e) {
    print(red('⯀ Failed to build Freezed classes: ${e.errorMessage}'));
  }

  print(green('\nConfig files created successfully', bold: false));
  exit(0);
}

void editYaml() {
  final filePath = 'pubspec.yaml';
  final fileContent = read(filePath).toParagraph();
  final editor = YamlEditor(fileContent);

  // Create keys if they don't exist
  editor.update(['flutter'], {'generate': null, 'assets': null});
  editor.update(['flutter', 'generate'], true);
  editor.update(['flutter', 'assets'], ['assets/', 'assets/images/']);

  filePath.write(editor.toString());
  print(green('pubspec.yaml updated successfully'));
}

extension PackagesError on Object {
  String get errorMessage => toString().split('\n').first;
}
