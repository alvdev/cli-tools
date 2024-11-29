import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

class CmsKit {
  final String kit;

  /// [kit] must be 'plain' or 'starter'
  const CmsKit(this.kit);

  /// Return the directory name of the installed project
  String install() {
    final String composerCmd = 'composer create-project getkirby/${kit}kit';

    while (true) {
      final projectDirName = ask('\nEnter name of the directory:',
          toLower: true,
          validator: Ask.regExp(r'^[a-z0-9._-]*$',
              error:
                  'Only lowercase letters, numbers, periods, underscores and hyphens are allowed.'));

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

  static void activate(String? projectDirName) {
    // if (!exists(join(current, 'kirby'))) {
    //   print(orange(
    //       '\nNo Kirby project found.\nPlease, run "mycli" in Kirby project root directory.'));
    //   exit(1);
    // }
    print(white('\n⯀ Activating CMS in "$projectDirName"'));

    final srcBasePath = join(projectDirName!, 'kirby', 'src');
    final Map<String, dynamic> files = {
      'view': {
        'path': join(srcBasePath, 'Panel', 'View.php'),
        'strOld': RegExp(
            r"'\$license'\s*=>\s*\$kirby->system\(\)->license\(\)->status\(\)->value\(\),"),
        'strNew': "'\$license' => '',",
      },
      'license': {
        'path': join(srcBasePath, 'Cms', 'License.php'),
        'strOld': 'return \$this->type()->label();',
        'strNew': 'return LicenseType::Basic->label();',
        'strOld2': RegExp(
            r'\$this->isMissing\(\)\s*===\s*true\s*=>\s*LicenseStatus::Missing,'),
        'strNew2': "\$this->isMissing()  === true => LicenseStatus::Active,",
      },
      'licenseStatus': {
        'path': join(srcBasePath, 'Cms', 'LicenseStatus.php'),
        'strOld': RegExp(
            r"return\s+I18n::template\('license\.status\.'\s*\.\s*\$this->value\s*\.\s*'\.info',\s*\[\s*'date'\s*=>\s*\$end\s*\]\);"),
        'strNew':
            "return I18n::template('license.status.' . \$this->value . '.info', ['date' => date('J F, Y', strtotime('now'))]);",
      },
      'licenseType': {
        'path': join(srcBasePath, 'Cms', 'LicenseType.php'),
        'strOld': 'Kirby Basic',
        'strNew': 'Professional',
      },
    };

    files.forEach((key, value) {
      try {
        final content = read(value['path']).toParagraph();

        if (content.contains(value['strOld'])) {
          replace(value['path'], value['strOld'], value['strNew']);
          if (key == 'license') {
            replace(value['path'], value['strOld2'], value['strNew2']);
          }

          value['strOld'].allMatches(content).forEach((match) {
            print("""
${blue("\nExisting in ${basename(value['path'])}:")}
  ${match.group(0)}
${blue("has been replaced with:")}
  ${value['strNew']}""");
          });
        } else {
          print("""
${red('There is no matches in ${basename(value['path'])} for:')}
  ${value['strOld'].toString()}
""");
        }
      } catch (e) {
        print(red('\nThere was an error: ${e.toString()}'));
      }
    });
  }

  static void update() {
    if (!exists(join(current, 'kirby'))) {
      print(orange(
          '\nNo Kirby project found.\nPlease, run "mycli" in a Kirby project root directory.'));
      return;
    }

    final projectDirName = dirname(basename(current));

    print(white('\n⯀ Updating CMS in "$projectDirName"\n'));
    'composer update'.run;

    activate(projectDirName);
  }
}
