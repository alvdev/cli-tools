import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// App extensions
extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Utils extensions
extension StringExtension on String {
  String toCamelCase() {
    final names = '${this[0].toLowerCase()}${substring(1)}';
    return names.replaceAll(RegExp(r'[ _-]+'), '');
  }
}
