import 'package:dcli/dcli.dart';
import 'package:mycli/kirby/kits.dart';
import 'package:mycli/kirby/shared/cms_kit.dart';
import 'package:mycli/main_menu.dart';

void kirbyMenu() {
  'clear'.run;
  print('# Kirby project selector\n');

  const options = [
    'Influencers',
    'Tattoo shops',
    'Bars & restaurants',
    'Pubs & discos',
    'Real estate',
    'Dental clinics\n',
    'Update CMS\n',
    '<< Back',
  ];
  final selected = menu('\nSelect theme:', options: options);

  if (selected == options[0]) installInfluencersKit();
  if (selected == options[6]) CmsKit.update();

  if (selected == options.last) mainMenu();
}
