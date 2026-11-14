import 'package:astro_prompt/config/event_planner_config.dart';

class MarathonConfig {
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.venzo.astroPrompt';

  static String websiteListUrl() =>
      '${EventPlannerConfig.shareSiteOrigin}/astroconnect';

  static String websiteDetailUrl(Object idOrSlug) =>
      '${EventPlannerConfig.shareSiteOrigin}/astroconnect/$idOrSlug';

  static String websiteBookingUrl(int id) =>
      '${EventPlannerConfig.shareSiteOrigin}/astroconnect/booking/$id';

  static String supportWhatsAppUrl() {
    const text =
        'Hello Teksage Support,\n\nI would like assistance with my account. Please find the details of my request below:\n\n[Teksage Support]';
    return 'https://wa.me/919840178216?text=${Uri.encodeComponent(text)}';
  }

  static const consentKeyword = 'Yes';
  static const consentIntro =
      'Please keep me updated when events matching my interests are available.';
  static const channelUrl =
      'https://www.whatsapp.com/channel/0029Vb7cSKBInlqIhwnlcz20';
  static const instagramUrl = 'https://www.instagram.com/teksage.app/';

  static String consentPrefill({
    String? name,
    List<String>? categories,
  }) {
    final lines = <String>[consentKeyword, '', consentIntro];
    final cleanName = name?.trim() ?? '';
    if (cleanName.isNotEmpty) lines.add('Name: $cleanName');
    final cats = (categories ?? [])
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    if (cats.isNotEmpty) lines.add('Interested in: ${cats.join(', ')}');
    return lines.join('\n');
  }

  static String consentWhatsAppUrl({
    String? prefill,
    String? name,
    List<String>? categories,
  }) {
    final text = prefill ?? consentPrefill(name: name, categories: categories);
    return 'https://wa.me/919840178216?text=${Uri.encodeComponent(text)}';
  }
}
