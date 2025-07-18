import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

class CmsKit {
  final String kit;
  String projectDirName = '';

  /// [kit] must be 'plain' or 'starter'
  CmsKit(this.kit);

  String get _projectDirName => projectDirName = askProjectDirName();

  void get kirbyDirNotFound {
    print(red(
        "\nNo Kirby project found.\nPlease, run \"mycli\" in a Kirby project root directory."));
    exit(1);
  }

  void get kirbyDirAlreadyExists {
    print(red(
        "\nA Kirby project was found in this directory.\nPlease, run \"mycli\" in a new directory."));
    exit(1);
  }

  String askProjectDirName() {
    return ask(
      '\nEnter name of the directory:',
      toLower: true,
      validator: Ask.regExp(r'^[a-z0-9._-]*$',
          error:
              'Only lowercase letters, numbers, periods, underscores and hyphens are allowed.'),
    );
  }

  /// Return the directory name of the installed project
  String install() {
    if (exists('kirby')) kirbyDirAlreadyExists;

    final String composerCmd = 'composer create-project getkirby/${kit}kit';

    while (true) {
      _projectDirName; // call _projectDirName getter to set projectDirName
      if (!exists(projectDirName)) {
        try {
          final isConfirmed = confirm(
            "\nYou are about to create a new CMS project in:\n${yellow('$pwd/$projectDirName', bold: false)}\nContinue?",
            defaultValue: true,
          );
          if (!isConfirmed) continue;

          print(white('\n⯀ Installing CMS "$kit kit" ...\n'));
          '$composerCmd $projectDirName'.run;
          print(green('\n[+] Added CMS "$kit kit"', bold: false));
          return projectDirName;
        } catch (e) {
          print(red('Error creating directory:$e'));
        }
      } else {
        print(orange('Folder already exists. Try again.', bold: false));
      }
    }
  }

  void activate() {
    // Check if install() was called. If not, the projectDirName is empty.
    if (projectDirName.isEmpty && !exists('kirby')) kirbyDirNotFound;
    // Take the project dir name from install() or pwd
    if (projectDirName.isNotEmpty) {
      print(
          white('\n⯀ Activating CMS in "${join(current, projectDirName)}"\n'));
    } else if (exists('kirby')) {
      print(white('\n⯀ Activating CMS in "$current"\n'));
    }

    final srcBasePath = join(projectDirName, 'kirby', 'src');
    final pluginsBasePath = join(projectDirName, 'site', 'plugins');

    final Map<String, dynamic> files = {
      'view': {
        'path': join(srcBasePath, 'Panel', 'View.php'),
        'strOld': RegExp(
            r"'\$license'\s*=>\s*\$kirby->system\(\)->license\(\)->status\(\)->value\(\),"),
        'strOldRaw':
            '\$license => \$kirby->system()->license()->status()->value(),',
        'strNew': "'\$license' => '',",
      },
      'license': {
        'path': join(srcBasePath, 'Cms', 'License.php'),
        'strOld': RegExp(
            r'if \(\$this->status\(\) === LicenseStatus::Missing\) \{\n\s*return LicenseType::Invalid->label\(\);\n\s*\}'),
        'strOldRaw':
            'if (\$this->status() === LicenseStatus::Missing) {\n      return LicenseType::Invalid->label();\n  }',
        'strNew':
            'if (\$this->status() === LicenseStatus::Active) {\n\t\t\treturn LicenseType::Basic->label();\n\t\t}',
        'strNewRaw':
            '\$this->status() === LicenseStatus::Active) {\n      return LicenseType::Basic->label();\n  }',
        'strOld2':
            RegExp(r'\$this->isMissing\(\)\s*=>\s*LicenseStatus::Missing,'),
        'strOld2Raw': '\$this->isMissing()\t=> LicenseStatus::Missing',
        'strNew2': "\$this->isMissing()\t=> LicenseStatus::Active,",
      },
      'licenseStatus': {
        'path': join(srcBasePath, 'Cms', 'LicenseStatus.php'),
        'strOld': RegExp(
            r"return\s+I18n::template\('license\.status\.'\s*\.\s*\$this->value\s*\.\s*'\.info',\s*\[\s*'date'\s*=>\s*\$end\s*\]\);"),
        'strOldRaw':
            'return I18n::template(\'license.status.\' . \$this->value . \'.info\', [\'date\' => \$end]);',
        'strNew':
            "return I18n::template('license.status.' . \$this->value . '.info', ['date' => date('J F, Y', strtotime('now'))]);",
      },
      'licenseType': {
        'path': join(srcBasePath, 'Cms', 'LicenseType.php'),
        'strOld': 'Kirby Basic',
        'strNew': 'Professional',
      },
      'dreamformLicense': {
        'path': join(pluginsBasePath, 'kirby-dreamform', 'classes', 'Support',
            'License.php'),
        'strOld': RegExp(
            r'if\s*\(\s*!\s*\$this->isSigned\s*\(\s*\)\s*\|\|\s*!\s*\$this->isComplete\s*\(\s*\)\s*\)\s*\{\s*return\s+false\s*;\s*\}'),
        'strOldRaw':
            'if (!\$this->isSigned() || !\$this->isComplete()) {\n      return false;\n  }',
        'strNew':
            'if (!\$this->isSigned() || !\$this->isComplete()) {\n\t\t\treturn true;\n\t\t}',
        'strNewRaw':
            'if (!\$this->isSigned() || !\$this->isComplete()) {\n      return true;\n  }',
      }
    };

    // Needed to check the last entry to print a message
    final entries = files.entries.toList();

    for (final entry in files.entries) {
      try {
        final content = File(entry.value['path']).readAsStringSync();

        if (content.contains(entry.value['strOld'])) {
          String updatedContent =
              content.replaceAll(entry.value['strOld'], entry.value['strNew']);
          if (entry.value.containsKey('strOld2')) {
            updatedContent = updatedContent.replaceAll(
                entry.value['strOld2'], entry.value['strNew2']);
          }
          File(entry.value['path']).writeAsStringSync(updatedContent);

          entry.value['strOld'].allMatches(content).forEach((match) {
            print("""
${blue("Existing in ${entry.value['path']}:")}
  ${entry.value['strOld'] is RegExp ? (entry.value['strOldRaw'] ?? entry.value['strOld']) : entry.value['strOld']}
${blue("has been replaced with:")}
  ${entry.value['strOld'] is RegExp ? (entry.value['strNewRaw'] ?? entry.value['strNew']) : entry.value['strNew']}
            """);
          });

          if (entry.value.containsKey('strOld2')) {
            entry.value['strOld2'].allMatches(content).forEach((match) {
              print("""
${blue("Existing in ${entry.value['path']}:")}
  ${entry.value['strOld2'] is RegExp ? (entry.value['strOld2Raw'] ?? entry.value['strOld2'].toString()) : entry.value['strOld2'].toString()}
${blue("has been replaced with:")}
  ${entry.value['strOld2'] is RegExp ? (entry.value['strNew2Raw'] ?? entry.value['strNew2']) : entry.value['strNew2']}
              """);
            });
          }
        } else {
          print("""
${red('There is no matches in ${entry.value['path']} for:')}
  ${entry.value['strOld'] is RegExp ? (entry.value['strOldRaw'] ?? entry.value['strOld']) : entry.value['strOld']}
${red('Nothing has been changed.')}
""");
          if (entry.key == entries.last.key) {
            print(blue('This project seems to be already activated.'));
          }
        }
      } catch (e) {
        print(red('\nThere was an error: ${e.toString()}'));
      }
    }
  }

  void update() {
    if (!exists('kirby')) return;

    projectDirName = dirname(basename(current));

    print(white('\n⯀ Updating CMS in "$projectDirName"\n'));
    'composer update'.run;

    activate();
  }
}
