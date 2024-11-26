import 'dart:io';
import 'package:dcli/dcli.dart';

void addPackages() {
  const Map<String, String> packages = {
    'Dio': 'dio',
    
    // Envied
    'Envied': 'envied',
    'Envied Generator': 'dev:envied_generator',

    // Internationalization
    'Flutter Localizations': 'flutter_localizations --sdk=flutter',
    'Internationalization': 'intl',

    'Go Router': 'go_router',
    'Flutter Riverpod': 'flutter_riverpod',
    'Flutter SVG': 'flutter_svg',

    // Freezed
    'Freezed Annotation': 'freezed_annotation',
    'Build Runner': 'dev:build_runner',
    'Freezed': 'dev:freezed',
    'JSON Annotation': 'dev:json_annotation',
    'JSON Serializable': 'dev:json_serializable',

    'Run Build Runner': 'build_runner -d',
  };
  final Map<String, List<String>> errors = {};

  for (final pkg in packages.entries) {
    String cmd = '';
    String msg = '';
    String errMsg = '';

    if (pkg.key != 'Run Build Runner') {
      cmd = 'flutter pub add ${pkg.value}';
      msg = '⯀ Added ${pkg.key}';
      errMsg = '⯀ Failed to add ${pkg.value}';
    } else {
      cmd = 'dart run build_runner build';
      msg = '⯀ Code generation completed';
      errMsg = '⯀ Failed to complete code generation';
    }

    try {
      cmd.start(
        progress: Progress(devNull, stderr: (error) {
            if (errors[pkg.key] == null) {
              errors[pkg.key] = [];
            }
            errors[pkg.key]!.add(error);
          }),
        runInShell: Platform.isWindows, // Fir for windows
        terminal: Platform.isWindows, // Fix for Windows
        nothrow: Platform.isWindows, // Fix for Windows
      );
      print(green(msg, bold: false));
    } catch (e) {
      print(red('$errMsg ${e.errorMessage}'));
      for (String error in errors[pkg.key]!) {
        print(red(error));
      }
    }
  }
}

extension StringExtension on String {
  String toCamelCase() {
    final names = '${this[0].toLowerCase()}${substring(1)}';
    return names.replaceAll(RegExp(r'[ _-]+'), '');
  }
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
