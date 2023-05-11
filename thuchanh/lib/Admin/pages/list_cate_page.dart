import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListCategoryPage extends StatefulWidget {
  static String routeName = "/list_category_screen";

  @override
  _ListCategoryPageState createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  List<dynamic> categories = [];
  bool showModal = false;
  String selectedId = '';
  Map<String, dynamic> newCategory = {
    'title': '',
    'image': '',
  };

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://192.168.15.109:8000/api/categories'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categories = data['categories'];
      });
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  void handleEdit(String id) {
    final selectedCategory =
        categories.firstWhere((category) => category['_id'] == id);
    setState(() {
      selectedId = id;
      showModal = true;
      newCategory['title'] = selectedCategory['title'];
      newCategory['image'] = selectedCategory['image'];
    });
  }

  void handleDelete(String id) {
    final selectedCategory =
        categories.firstWhere((category) => category['_id'] == id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa danh mục'),
          content: Text(
              'Bạn có chắc chắn muốn xóa danh mục "${selectedCategory['title']}"?'),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                deleteCategory(selectedCategory['_id']);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addCategory() async {
    final response = await http.post(
        Uri.parse('http://192.168.15.109:8000/api/categories'),
        body: newCategory);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      setState(() {
        categories.add(data);
      });
      showToast('Thêm danh mục thành công');
      closeModal();
      fetchCategories();
    } else {
      showToast('Thêm danh mục thất bại');
    }
  }

  Future<void> updateCategory() async {
    final response = await http.put(
        Uri.parse('http://192.168.15.109:8000/api/categories/$selectedId'),
        body: newCategory);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categories = categories
            .map((category) => category['_id'] == selectedId ? data : category)
            .toList();
      });
      showToast('Cập nhật danh mục thành công');
      closeModal();
      fetchCategories();
    } else {
      showToast('Cập nhật danh mục thất bại');
    }
  }

  Future<void> deleteCategory(String id) async {
    final response = await http
        .delete(Uri.parse('http://192.168.15.109:8000/api/categories/$id'));
    if (response.statusCode == 200) {
      setState(() {
        categories.removeWhere((category) => category['_id'] == id);
      });
      showToast('Xóa danh mục thành công');
    } else {
      showToast('Xóa danh mục thất bại');
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
      newCategory['title'] = '';
      newCategory['image'] = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý danh mục"),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text("ID: ${category['_id']}"),
            subtitle: Text(
                "Title: ${category['title']}\nImage: ${category['image']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => handleEdit(category['_id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => handleDelete(category['_id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => showModal = true),
        child: Icon(Icons.add),
      ),
      bottomSheet: showModal ? buildCategoryForm() : null,
    );
  }

  Widget buildCategoryForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedId.isNotEmpty ? 'Sửa thông tin danh mục' : 'Thêm danh mục',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            onChanged: (value) => newCategory['title'] = value,
            controller: TextEditingController(text: newCategory['title']),
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(labelText: 'Image'),
            onChanged: (value) => newCategory['image'] = value,
            controller: TextEditingController(text: newCategory['image']),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: selectedId.isNotEmpty ? updateCategory : addCategory,
            child: Text(selectedId.isNotEmpty ? 'Lưu' : 'Thêm'),
          ),
          SizedBox(height: 8.0),
          TextButton(
            onPressed: closeModal,
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
