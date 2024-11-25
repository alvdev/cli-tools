import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:yaml_edit/yaml_edit.dart';
import 'package:add_flutter_feature/add_packages.dart';
import 'package:add_flutter_feature/replace_vars.dart';

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

  print(white('\n\n⯀ Copying files...\n'));
  for (final f in skeletonRootFiles) {
    if (exists(basename(f))) {
      print(blue('⯀ ${basename(f)} exists. Backup file created.'));
      move(basename(f), '${basename(f)}.bak', overwrite: true);
    }

    print(green('⯀ ${basename(f)} created\n', bold: false));
    copy(f, relative('./'), overwrite: true);
  }

  copyTree(
    '$skeletonDir/lib/',
    relative('lib/'),
    overwrite: true,
    filter: (f) => !f.contains('/feature_skeleton/'),
    // TODO: still copying features folder on Windows
  );

  replaceVars();
  print(green('⯀ lib folder created', bold: false));

  // edit pubspec.yaml before adding packages.Otherwise it will fail
  editYaml();

  // Add dependencies after copying skeleton. Otherwise it will fail
  print(white('\n\n⯀ Adding packages...\n'));
  addPackages();

  print(white('\n👍 Config files created successfully', bold: true));
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
  print(green('⯀ pubspec.yaml updated', bold: false));
}

extension PackagesError on Object {
  String get errorMessage {
    final output = toString().split('\n');
    output.removeAt(0); // Remove command
    output.removeAt(0); // Remove exit code
    final newOutput =
        output.join().replaceAll('workingDirectory', '\nworkingDirectory');
    return '\n$newOutput';
  }
}
