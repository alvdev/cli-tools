import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

void replaceVars() {
  final appRootDir = current;
  final appPackageName = basename(appRootDir);

  find('*', workingDirectory: '$appRootDir/lib').forEach((file) {
    final content = read(file).toParagraph();
    if (content.contains('{{ appPackageName }}')) {
      replace(file, '{{ appPackageName }}', appPackageName);
    }
  });
}
