import 'package:schedule_sgk/models/item.dart';

class Group extends Item {
  int id;
  String name;
  bool favorite;

  Group({required this.id, required this.name, required this.favorite});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      favorite: false,
    );
  }

  @override
  String getKey() => id.toString();

  @override
  bool getFavorite() => favorite;

  @override
  String getAuthor() => name;
}
