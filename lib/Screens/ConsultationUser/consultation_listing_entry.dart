class ConsultationListingEntry {
  final int userId;
  final String? picture;
  final String? firstName;
  final String? lastName;
  final List<String> languages;
  final double localConsultingFee;
  final double foreignConsultingFee;

  const ConsultationListingEntry({
    required this.userId,
    required this.picture,
    required this.firstName,
    this.lastName,
    required this.languages,
    required this.localConsultingFee,
    required this.foreignConsultingFee,
  });
}
