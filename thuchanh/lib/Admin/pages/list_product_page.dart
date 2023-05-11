import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListFoodPage extends StatefulWidget {
  static String routeName = "/list_food_screen";

  const ListFoodPage({super.key});

  @override
  _ListFoodPageState createState() => _ListFoodPageState();
}

class _ListFoodPageState extends State<ListFoodPage> {
  List<dynamic> foods = [];
  bool showModal = false;
  String selectedId = '';
  String? selectedCategory = '';
  Map<String, dynamic> newFood = {
    'title': '',
    'description': '',
    'image': '',
    'price': '',
    'quantity': 0,
    'category': '',
  };
  List<dynamic> categories = []; // Danh sách các category

  @override
  void initState() {
    super.initState();
    fetchFoods();
    fetchCategories(); // Tải danh sách category
  }

  Future<void> fetchFoods() async {
    final response =
        await http.get(Uri.parse('http://192.168.15.109:8000/api/food'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['food'] is List) {
        setState(() {
          foods = data['food'];
        });
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch foods');
    }
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://192.168.15.109:8000/api/categories'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data); // In ra nội dung phản hồi từ máy chủ
      if (data['categories'] is List) {
        setState(() {
          categories = data['categories'];
          if (categories.isNotEmpty) {
            selectedCategory = categories[0]['_id'];
          }
        });
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  void handleEdit(String id) {
    final selectedFood = foods.firstWhere((food) => food['_id'] == id);
    setState(() {
      selectedId = id;
      showModal = true;
      newFood['title'] = selectedFood['title'];
      newFood['description'] = selectedFood['description'];
      newFood['image'] = selectedFood['image'];
      newFood['price'] = selectedFood['price'];
      newFood['quantity'] = selectedFood['quantity'];
      newFood['category'] = selectedFood['category']['_id'];
    });
  }

  void handleDelete(String id) {
    final selectedFood = foods.firstWhere((food) => food['_id'] == id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete the food "${selectedFood['title']}"?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteFood(selectedFood['_id']);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addFood() async {
    final response = await http.post(
      Uri.parse('http://192.168.15.109:8000/api/food'),
      body: jsonEncode(newFood),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      setState(() {
        foods.add(data);
      });
      showToast('Food added successfully');
      closeModal();
      fetchFoods();
    } else {
      showToast('Failed to add food');
    }
  }

  Future<void> updateFood() async {
    final response = await http.put(
      Uri.parse('http://192.168.15.109:8000/api/food/$selectedId'),
      body: jsonEncode(newFood),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        foods = foods
            .map((food) => food['_id'] == selectedId ? data : food)
            .toList();
      });
      showToast('Food updated successfully');
      closeModal();
      fetchFoods();
    } else {
      showToast('Failed to update food');
    }
  }

  Future<void> deleteFood(String id) async {
    final response =
        await http.delete(Uri.parse('http://192.168.15.109:8000/api/food/$id'));
    if (response.statusCode == 200) {
      setState(() {
        foods.removeWhere((food) => food['_id'] == id);
      });
      showToast('Food deleted successfully');
    } else {
      showToast('Failed to delete food');
    }
  }

  void showToast(String message) {
    // Implement your preferred toast notification here
    // For example, you can use the Fluttertoast package
    // Fluttertoast.showToast(msg: message);
  }

  void closeModal() {
    setState(() {
      showModal = false;
      selectedId = '';
      newFood['title'] = '';
      newFood['description'] = '';
      newFood['image'] = '';
      newFood['price'] = '';
      newFood['quantity'] = 0;
      newFood['category'] = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Management"),
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return ListTile(
            title: Text("ID: ${food['_id']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: ${food['title']}"),
                Text("Description: ${food['description']}"),
                Text("image: ${food['image']}"),
                Text("Price: ${food['price']}"),
                Text("quantity: ${food['quantity']}"),
                Text("category: ${food['category']}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => handleEdit(food['_id']),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => handleDelete(food['_id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => showModal = true),
        child: const Icon(Icons.add),
      ),
      bottomSheet: showModal ? buildFoodForm() : null,
    );
  }

  Widget buildFoodForm() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedId.isNotEmpty ? 'Edit Food' : 'Add Food',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => newFood['title'] = value,
              controller: TextEditingController(text: newFood['title']),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => newFood['description'] = value,
              controller: TextEditingController(text: newFood['description']),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Image'),
              onChanged: (value) => newFood['image'] = value,
              controller: TextEditingController(text: newFood['image']),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Price'),
              onChanged: (value) => newFood['price'] = value,
              controller: TextEditingController(text: newFood['price']),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              onChanged: (value) => newFood['quantity'] = int.parse(value),
              controller:
                  TextEditingController(text: newFood['quantity'].toString()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              value: selectedCategory ?? '',
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['_id'],
                  child: Text(category['title']),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: selectedId.isNotEmpty ? updateFood : addFood,
              child: Text(selectedId.isNotEmpty ? 'Update' : 'Add'),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: closeModal,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
