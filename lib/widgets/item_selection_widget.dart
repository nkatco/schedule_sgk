import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_sgk/repositories/favorites_repository.dart';

class ItemSelectionWidget extends StatefulWidget {
  @override
  _ItemSelectionWidgetState createState() => _ItemSelectionWidgetState();
}

class _ItemSelectionWidgetState extends State<ItemSelectionWidget> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    FavoritesRepository favoritesRepository = FavoritesRepository();
    List<Map<String, dynamic>> authors = await favoritesRepository.getAllFavorite();

    setState(() {
      items = authors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        item['author'],
                        textAlign: TextAlign.center,
                      ),
                      onTap: () async {
                        await saveToSharedPreferences(item);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ],
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text(
              'Выбранный предмет будет отображаться в виджете',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveToSharedPreferences(Map<String, dynamic> item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('widget_key', item['key']);
    prefs.setString('widget_author', item['author']);
    prefs.setString('widget_type', item['type']);
  }
}