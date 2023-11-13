import 'package:schedule_sgk/models/item.dart';

class Teacher extends Item {
  int id;
  String name;

  Teacher({required this.id, required this.name});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: int.parse(json['id']),
      name: json['name'],
    );
  }
  @override
  String getAuthor() => name;
}
