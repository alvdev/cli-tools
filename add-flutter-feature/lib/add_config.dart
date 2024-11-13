import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:yaml_edit/yaml_edit.dart';
// import 'package:yaml_edit/yaml_edit.dart';

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
  editPubspec('pubspec.yaml');

  // Add dependencies after copying skeleton. Otherwise it will fail
  print(blue('Adding packages...'));

  try {
    'flutter pub add dio'.start(detached: false);
    print(cyan('\t-> Added Dio package'));
  } catch (e) {
    print(red('\t-> Failed to add Dio package: $e'));
  }

  try {
    'flutter pub add envied'.start(detached: false);
    print(cyan('\t-> Added Envied package'));
  } catch (e) {
    print(red('\t-> Failed to add Envied package: $e'));
  }

  try {
    'flutter pub add flutter_localizations --sdk=flutter'.start(detached: true);
    'flutter pub add intl'.start(detached: true);
    print(cyan('\t-> Added Internationalization packages'));
  } catch (e) {
    print(red('\t-> Failed to add Internationalization packages: $e'));
  }

  try {
    'flutter pub add go_router'.start(detached: true);
    print(cyan('\t-> Added Go Router package'));
  } catch (e) {
    print(red('\t-> Failed to add Go Router package: $e'));
  }

  try {
    'flutter pub add flutter_riverpod'.start(detached: true);
    print(cyan('\t-> Added Flutter Riverpod package'));
  } catch (e) {
    print(red('\t-> Failed to add Flutter Riverpod package: $e'));
  }

  try {
    'flutter pub add flutter_svg'.start(detached: true);
    print(cyan('\t-> Added Flutter SVG package'));
  } catch (e) {
    print(red('\t-> Failed to add Flutter SVG package: $e'));
  }

  try {
    'flutter pub add freezed_annotation'.start(detached: true);
    'flutter pub add dev:build_runner'.start(detached: true);
    'flutter pub add dev:freezed'.start(detached: true);
    'flutter pub add add json_annotation'.start(detached: true);
    'flutter pub add dev:json_serializable'.start(detached: true);
    print(cyan('\t-> Added Freezed packages'));
  } catch (e) {
    print(red('\t-> Failed to add Freezed packages: $e'));
  }

  print(green('Config files created successfully'));
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

  file.writeAsString(editor.toString());
}
