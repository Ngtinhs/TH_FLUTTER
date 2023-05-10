import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Food {
  final String title;

  Food({required this.title});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      title: json['title'],
    );
  }
}

class FoodListPage extends StatefulWidget {
  final String categoryId;

  FoodListPage({required this.categoryId});

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  late Future<List<Food>> foodsFuture;

  @override
  void initState() {
    super.initState();
    foodsFuture = fetchFoods();
  }

  Future<List<Food>> fetchFoods() async {
    final response = await http.get(Uri.parse(
        'http://192.168.15.109:8000/api/categories/${widget.categoryId}'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> foodData = jsonData['foods'];
      return foodData.map((food) => Food.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food List'),
      ),
      body: FutureBuilder<List<Food>>(
        future: foodsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
