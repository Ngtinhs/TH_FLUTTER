import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Categories {
  final String image;

  Categories({required this.image});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      image: json['image'],
    );
  }
}

Future<List<Categories>> fetchCategories() async {
  final response =
      await http.get(Uri.parse('http://192.168.15.109:8000/api/categories'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return (jsonData['categories'] as List)
        .map((categoryData) => Categories.fromJson(categoryData))
        .toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

class CategoriesStore extends StatefulWidget {
  const CategoriesStore({Key? key}) : super(key: key);

  @override
  _CategoriesStoreState createState() => _CategoriesStoreState();
}

class _CategoriesStoreState extends State<CategoriesStore> {
  late Future<List<Categories>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                Text(
                  'See more',
                  style: TextStyle(fontSize: 16, color: Colors.lightGreen),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<Categories>>(
              future: categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CategoriesItem(category: snapshot.data![index]);
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesItem extends StatelessWidget {
  final Categories category;

  const CategoriesItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(5),
      child: Image.asset(category.image),
    );
  }
}
