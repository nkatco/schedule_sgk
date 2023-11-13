class Cabinet {
  String id;
  String name;

  Cabinet({required this.id, required this.name});

  factory Cabinet.fromJson(Map<String, dynamic> json) {
    return Cabinet(
      id: json['id'],
      name: json['name'],
    );
  }
}