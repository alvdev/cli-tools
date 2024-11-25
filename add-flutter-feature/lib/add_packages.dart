import 'package:dcli/dcli.dart';

void addPackages() {
  const Map<String, String> packages = {
    'Dio': 'dio',
    'Envied': 'envied',

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
      msg = '⯀ Adding ${pkg.key}';
      errMsg = '⯀ Failed to add ${pkg.value}';
    } else {
      cmd = 'dart run build_runner build';
      msg = '⯀ Running Build Runner';
      errMsg = '⯀ Failed to run Build Runner';
    }

    try {
      cmd.start(
          progress: Progress(devNull, captureStdout: false, stderr: (error) {
            if (errors[pkg.key] == null) {
              errors[pkg.key] = [];
            }
            errors[pkg.key]!.add(error);
          }),
        runInShell: true,
        terminal: true, // Fix for Windows
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
