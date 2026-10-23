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
}
