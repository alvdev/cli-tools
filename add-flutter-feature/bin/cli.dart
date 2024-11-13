import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:add_flutter_feature/add_config.dart';
import 'package:add_flutter_feature/add_feature.dart';

void main() {
  if (!exists('pubspec.yaml')) {
    print('Please run this script from the root of your Flutter project');
    exit(0);
  }

  const options = ['Create config files', 'Create a new feature'];
  final selected = menu(
    options: options,
    '\nSelect an option:',
  );

  final isConfirmedOption = confirm(
    "\nYou're going to ${orange(selected.toLowerCase())}. Are you sure?",
    defaultValue: false,
  );
  if (!isConfirmedOption) exit(0);

  if (selected == options[0]) addConfigFiles();
  if (selected == options[1]) addFeatureFiles();
}
