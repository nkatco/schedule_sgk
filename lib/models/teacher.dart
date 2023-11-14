import 'package:schedule_sgk/models/item.dart';

class Teacher extends Item {
  int id;
  String name;
  bool favorite;

  Teacher({required this.id, required this.name, required this.favorite});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: int.parse(json['id']),
      name: json['name'],
      favorite: false
    );
  }

  @override
  String getKey() => id.toString();

  @override
  bool getFavorite() => favorite;

  @override
  String getAuthor() => name;
}
