import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:yaml_edit/yaml_edit.dart';

void addConfigFiles() async {
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

  // edit pubspec.yaml before adding packages.Otherwise it will fail
  await editPubspec('pubspec.yaml');

  // Add dependencies after copying skeleton. Otherwise it will fail
  print(blue('Adding packages...'));

  try {
    'flutter pub add dioss'.start(progress: Progress.devNull());
    print(green('🟢 Added Dio package', bold: false));
  } catch (e) {
    print(red('🔴 Failed to add Dio package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add envied'.start(progress: Progress.devNull());
    print(green('🟢 Added Envied package', bold: false));
  } catch (e) {
    print(red('🔴 Failed to add Envied package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add flutter_localizations --sdk=flutter'
        .start(progress: Progress.devNull());
    'flutter pub add intl'.start(progress: Progress.devNull());
    print(green('🟢 Added Internationalization packages', bold: false));
  } catch (e) {
    print(red(
        '🔴 Failed to add Internationalization packages: ${e.errorMessage}'));
  }

  try {
    'flutter pub add go_router'.start(progress: Progress.devNull());
    print(green('🟢 Added Go Router package', bold: false));
  } catch (e) {
    print(red('🔴 Failed to add Go Router package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add flutter_riverpod'.start(progress: Progress.devNull());
    print(green('🟢 Added Flutter Riverpod package', bold: false));
  } catch (e) {
    print(red('🔴 Failed to add Flutter Riverpod package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add flutter_svg'.start(progress: Progress.devNull());
    print(green('🟢 Added Flutter SVG package', bold: false));
  } catch (e) {
    print(red('🔴 Failed to add Flutter SVG package: ${e.errorMessage}'));
  }

  try {
    'flutter pub add freezed_annotation'.start(progress: Progress.devNull());
    'flutter pub add dev:build_runner'.start(progress: Progress.devNull());
    'flutter pub add dev:freezed'.start(progress: Progress.devNull());
    'flutter pub add add json_annotation'.start(progress: Progress.devNull());
    'flutter pub add dev:json_serializable'.start(progress: Progress.devNull());
    print(green('🟢 Added Freezed packages', bold: false));
  } catch (e) {
    print(red('🔴 Failed to add Freezed packages: ${e.errorMessage}'));
  }

  print(green('Config files created successfully'));
  exit(0);
}

Future<void> editPubspec(String path) async {
  final file = File(path);
  final yamlContent = await file.readAsString();
  final editor = YamlEditor(yamlContent);

  try {
    if (editor.parseAt(['flutter', 'generate']) is Map) {
      editor.update(['flutter', 'generate'], true);
    }
  } catch (e) {
    editor.update(['flutter'], {'generate': true});
  }

  await file.writeAsString(editor.toString());
}

extension PackagesError on Object {
  String get errorMessage => toString().split('\n').first;
}
