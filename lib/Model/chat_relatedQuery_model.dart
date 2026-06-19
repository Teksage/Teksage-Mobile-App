class RelatedQueriesModel {
  final List<String> queries;

  RelatedQueriesModel({required this.queries});

  factory RelatedQueriesModel.fromJson(Map<String, dynamic> json) {
    return RelatedQueriesModel(
      queries: List<String>.from(json['queries'] ?? []),
    );
  }
}
