import 'package:dcli/dcli.dart';

void main() {
  print('Testing...');

  final username = ask('username:');
  print(orange('Your username is $username'));

  final options = ['Option 1', 'Option 2', 'Option 3'];
  final selectedOption = menu('Select an option:', options: options);
  print(green('You have selected $selectedOption'));
}
