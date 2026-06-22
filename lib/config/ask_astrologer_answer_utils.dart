import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:intl/intl.dart';

String buildAstrologerPublicProfileUrl(String profilePath) {
  final path =
      profilePath.startsWith('/') ? profilePath : '/$profilePath';
  return '${AskAstrologerScreenCopy.publicSiteOrigin}$path';
}

String buildAstrologerPublicProfileDisplayUrl(String profilePath) {
  final path =
      profilePath.startsWith('/') ? profilePath : '/$profilePath';
  return '${AskAstrologerScreenCopy.publicSiteHost}$path';
}

String? formatAskAnswerDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return DateFormat('dd/MM/yyyy, h:mm a')
        .format(DateTime.parse(value).toLocal());
  } catch (_) {
    return null;
  }
}
