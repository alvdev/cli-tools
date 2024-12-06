import 'package:dcli/dcli.dart';
import 'package:mycli/kirby/shared/cms_kit.dart';

void installInfluencersKit() {
  final kit = CmsKit('plain');
  kit.install();
  kit.activate();

  print(white('\n⯀ Installing Influencers kit...'));
  // TODO: install Influencers kit
}
