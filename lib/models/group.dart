import 'package:schedule_sgk/models/item.dart';

class Group extends Item {
  int id;
  String name;

  Group({required this.id, required this.name});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
    );
  }
  @override
  String getAuthor() => name;
}
