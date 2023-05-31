import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'listmakanan.dart';

class KategoriPage extends StatefulWidget {
  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      setState(() {
        categories = jsonDecode(response.body)['categories'];
      });
    } else {
      // Handle error
      print('Gagal load kategori');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                category['strCategory'],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                category['strCategoryDescription'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Image.network(
                category['strCategoryThumb'],
                width: 56.0,
                height: 56.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListMakanan(category: category['strCategory']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
