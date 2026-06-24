class ConsultationListingEntry {
  final int userId;
  final String? picture;
  final String? firstName;
  final List<String> languages;
  final double localConsultingFee;
  final double foreignConsultingFee;

  const ConsultationListingEntry({
    required this.userId,
    required this.picture,
    required this.firstName,
    required this.languages,
    required this.localConsultingFee,
    required this.foreignConsultingFee,
  });
}
