import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailMakanan extends StatefulWidget {
  final String mealId;
  final String mealTitle;

  const DetailMakanan({
    Key? key,
    required this.mealId,
    required this.mealTitle,
  }) : super(key: key);

  @override
  _DetailMakananState createState() => _DetailMakananState();
}

class _DetailMakananState extends State<DetailMakanan> {
  Map<String, dynamic>? mealDetails;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));
    if (response.statusCode == 200) {
      setState(() {
        mealDetails = jsonDecode(response.body)['meals'][0];
      });
    } else {
      print('Failed to load meal details');
    }
  }

  void launchYouTubeVideo(String videoUrl) async {
    if (await canLaunch(videoUrl)) {
      await launch(videoUrl);
    } else {
      print('gagal membuka youtube');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mealTitle,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: mealDetails != null
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              child: ClipRect(
                child: Image.network(
                  mealDetails!['strMealThumb'],
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Category: ${mealDetails!['strCategory']}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Instructions: ${mealDetails!['strInstructions']}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  launchYouTubeVideo(mealDetails!['strYoutube']);
                },
                child: Text('Watch Video on YouTube'),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
