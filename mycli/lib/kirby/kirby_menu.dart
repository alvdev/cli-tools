import 'package:dcli/dcli.dart';
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
    '<< Back',
  ];
  final selected = menu('\nSelect theme:', options: options);

  if (selected == options.last) mainMenu();
}
