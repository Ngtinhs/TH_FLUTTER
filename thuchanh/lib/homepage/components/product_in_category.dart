import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:demo/model/products.dart';
import 'package:demo/model/utilities.dart';
import '../../../detail/productpage.dart';

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
  late Future<List<Products>> foodsFuture;

  @override
  void initState() {
    super.initState();
    foodsFuture = fetchFoods();
  }

  Future<List<Products>> fetchFoods() async {
    final response = await http.get(Uri.parse(
        'http://192.168.15.109:8000/api/categories/${widget.categoryId}'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> foodData = jsonData['foods'];
      List<Products> result = [];
      try {
        for (var element in foodData) {
          var data = Products(
            description: element['description'],
            title: element['title'],
            image: element['image'],
            price: double.parse(element['price']),
            quantity: element['quantity'],
            id: element['_id'],
          );
          result.add(data);
        }
      } catch (e) {
        print(e.toString());
      }
      return result;
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
      body: FutureBuilder<List<Products>>(
        future: foodsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('Không có food nào trong category này :>'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Utilities.result.add(snapshot.data![index]);
                    Navigator.pushNamed(
                      context,
                      ProductPage.routeName,
                      arguments: ProductDetailsArguments(
                        product: snapshot.data![index],
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            snapshot.data![index].image,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.data![index].title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            snapshot.data![index].price.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
