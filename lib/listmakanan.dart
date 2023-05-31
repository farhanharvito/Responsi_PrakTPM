import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detailmakanan.dart';

class ListMakanan extends StatefulWidget {
  final String category;

  const ListMakanan({Key? key, required this.category}) : super(key: key);

  @override
  _ListMakananState createState() => _ListMakananState();
}

class _ListMakananState extends State<ListMakanan> {
  List<dynamic> meals = [];

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));
    if (response.statusCode == 200) {
      setState(() {
        meals = jsonDecode(response.body)['meals'];
      });
    } else {
      // Handle error
      print('Gagal load meal');
    }
  }

  void navigateToMealDetail(String mealId, String mealTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMakanan(
          mealId: mealId,
          mealTitle: mealTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Meals'),
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  meal['strMealThumb'],
                  width: 72.0,
                  height: 72.0,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                meal['strMeal'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              onTap: () {
                navigateToMealDetail(meal['idMeal'], meal['strMeal']);
              },
            ),
          );
        },
      ),
    );
  }
}
