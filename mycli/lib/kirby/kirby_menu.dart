import 'package:dcli/dcli.dart';
import 'package:mycli/kirby/kits.dart';
import 'package:mycli/kirby/shared/cms_kit.dart';
import 'package:mycli/main_menu.dart';

void kirbyMenu() {
  'clear'.run;
  print('# Kirby project selector\n');

  final List<String> options = [
    'Influencers',
    'Tattoo shops',
    'Bars & restaurants',
    'Pubs & discos',
    'Real estate',
    'Dental clinics\n',
    "Update CMS \t${cyan('(activation included)')}",
    "Activate CMS\t${cyan('(activate only, no update)')}\n",
    '<< Back',
  ];
  final selected = menu('\nSelect theme:', options: options);

  if (selected == options[0]) installInfluencersKit();

  final kit = CmsKit('plain');
  if (selected == options[6]) kit.update();
  if (selected == options[7]) kit.activate();

  if (selected == options.last) mainMenu();
}
