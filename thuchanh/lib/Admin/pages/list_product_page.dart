import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodList extends StatefulWidget {
  static String routeName = "/list_food_screen";
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  List<dynamic> foods = [];
  bool showModal = false;
  dynamic selectedFood;
  dynamic selectedFoodToDelete;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    final response =
        await http.get(Uri.parse('http://192.168.15.109:8000/api/food'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        foods = data['food'];
      });
    } else {
      print('Error fetching food list: ${response.statusCode}');
    }
  }

  void handleAddFood() {
    setState(() {
      selectedFood = {
        'title': '',
        'description': '',
        'price': '',
        'images': [],
      };
      isEditing = false;
      showModal = true;
    });
  }

  void handleEditFood(dynamic food) {
    setState(() {
      selectedFood = food;
      isEditing = true;
      showModal = true;
    });
  }

  void handleDeleteFood(dynamic food) {
    setState(() {
      selectedFoodToDelete = food;
      showModal = true;
    });
  }

  void handleConfirmDelete() async {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.15.109:8000/api/food/${selectedFoodToDelete['_id']}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        foods.removeWhere((f) => f['_id'] == selectedFoodToDelete['_id']);
      });
      showToast('Xóa món ăn thành công');
      setState(() {
        showModal = false;
      });
    } else {
      print('Error deleting food: ${response.statusCode}');
      showToast('Xóa món ăn thất bại');
    }
  }

  void handleSaveFood() async {
    final title = selectedFood['title'];
    final description = selectedFood['description'];
    final price = selectedFood['price'];
    final image = selectedFood['image'];

    if (title != null &&
        description != null &&
        price != null &&
        image != null) {
      final formData = {
        'title': title,
        'description': description,
        'price': price,
        'image': image,
      };

      if (isEditing) {
        final response = await http.put(
          Uri.parse(
              'http://192.168.15.109:8000/api/food/${selectedFood['_id']}'),
          body: jsonEncode(formData),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final updatedFood = {
            ...selectedFood,
            'image': data['image'],
          };
          setState(() {
            foods = foods
                .map((f) => f['_id'] == selectedFood['_id'] ? updatedFood : f)
                .toList();
            showModal = false;
          });
          showToast('Cập nhật món ăn thành công');
        } else {
          print('Error updating food: ${response.statusCode}');
          showToast('Cập nhật món ăn thất bại');
        }
      } else {
        final response = await http.post(
          Uri.parse('http://192.168.15.109:8000/api/food'),
          body: jsonEncode(formData),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final newFood = {
            ...data,
            'image': 'public/images/${data['image']}',
          };
          setState(() {
            foods.add(newFood);
            showModal = false;
          });
          showToast('Thêm món ăn thành công');
        } else {
          print('Error adding food: ${response.statusCode}');
          showToast('Thêm món ăn thất bại');
        }
      }
    } else {
      showToast('Vui lòng điền đầy đủ thông tin món ăn và chọn ảnh');
    }
  }

  void showToast(String message) {
// Implement your toast notification logic here
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: handleAddFood,
              child: Text('Thêm món ăn'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return ListTile(
                    title: Text('Title: ${food['title']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${food['description']}'),
                        SizedBox(height: 8),
                        Image.network(
                          'http://localhost:3000/asset/foods/${food['image']}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Text('Price: ${food['price']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => handleEditFood(food),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => handleDeleteFood(food),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
// Handle floating action button press if needed
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
