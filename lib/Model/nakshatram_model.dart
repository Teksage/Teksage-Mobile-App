class NakshatraModel {
  final int id;
  final String name;
  final List<int> signs;

  NakshatraModel({required this.id, required this.name, required this.signs});

  factory NakshatraModel.fromJson(Map<String, dynamic> json) {
    return NakshatraModel(
      id: json['id'],
      name: json['name'],
      signs: List<int>.from(json['signs']),
    );
  }
}