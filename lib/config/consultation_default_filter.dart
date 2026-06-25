/// Default consultation filter when skipping category/language steps.
/// Mirrors web `defaultConsultationFilter()` — all topics + English.
class ConsultationDefaultFilter {
  static const List<String> categories = [
    'career',
    'wealth',
    'marriage & relationships',
    'health',
  ];

  static const List<String> languages = ['english'];
}
