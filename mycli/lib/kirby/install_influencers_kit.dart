import 'package:dcli/dcli.dart';
import 'package:mycli/kirby/shared/cms_kit.dart';

void installInfluencersKit() {
  final kit = CmsKit('plain');
  CmsKit.activate(kit.install());

  print(white('\n⯀ Installing Influencers kit...'));
  // TODO: install Influencers kit
}
