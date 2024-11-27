import 'package:dcli/dcli.dart';

/// [kit] must be 'plain' or 'starter'
void installKirbyKit(String kit) {
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
          "\nYou are about to create a new Kirby project in:\n${yellow('$pwd/$projectDirName', bold: false)}\nContinue?",
          defaultValue: true,
        );
        if (!isConfirmed) continue;

        print(white('Installing Kirby $kit ...'));
        '$composerCmd $projectDirName'.run;
        print(green('\n[+] Added Kirby $kit kit', bold: false));
        break;
      } catch (e) {
        print(red('Error creating directory:$e'));
      }
    } else {
      print(orange('Folder already exists. Try again.', bold: false));
    }
  }
}
