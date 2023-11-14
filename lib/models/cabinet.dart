import 'package:schedule_sgk/models/item.dart';

class Cabinet extends Item {
  String id;
  String name;
  bool favorite;

  Cabinet({required this.id, required this.name, required this.favorite});

  factory Cabinet.fromJson(Map<String, dynamic> json) {
    return Cabinet(
      id: json['id'],
      name: json['name'],
      favorite: false
    );
  }

  @override
  String getKey() => id;

  @override
  bool getFavorite() => favorite;

  @override
  String getAuthor() => name;
}