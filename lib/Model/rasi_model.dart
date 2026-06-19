class RasiModel {
  final int id;
  final String name;

  RasiModel({required this.id, required this.name});

  factory RasiModel.fromJson(Map<String, dynamic> json) {
    return RasiModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
