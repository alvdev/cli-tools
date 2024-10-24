import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as p;

void addFeatureFiles() {
  final featureName = ask(
    "Enter feature name: ",
    toLower: true,
    required: true,
  );
  
  final exeBaseDir = File(Platform.script.toFilePath()).parent.parent.path;
  final featureDirFrom = '$exeBaseDir/lib/_skeleton/lib/features/feature';
  final featureDirTo = p.relative('lib/features/$featureName');

  if (exists(featureDirTo)) {
    print('Feature folder already exists');
    exit(0);
  }

  if (!exists(featureDirTo)) {
    createDir(featureDirTo, recursive: true);
  }
  
  copyTree(featureDirFrom, featureDirTo);
  print('Feature created on $featureDirTo');
}
