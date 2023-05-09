import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListUserPage extends StatefulWidget {
  static String routeName = "/list_user_screen";

  @override
  _ListUserPageState createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  List<dynamic> users = [];
  bool showModal = false;
  String selectedId = '';
  Map<String, dynamic> newUser = {
    'username': '',
    'password': '',
  };

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://192.168.15.109:8000/api/users'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        users = data;
      });
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  void handleEdit(String id) {
    final selectedUser = users.firstWhere((user) => user['_id'] == id);
    setState(() {
      selectedId = id;
      showModal = true;
      newUser['username'] = selectedUser['username'];
      newUser['password'] = selectedUser['password'];
    });
  }

  void handleDelete(String id) {
    final selectedUser = users.firstWhere((user) => user['_id'] == id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa người dùng'),
          content: Text(
              'Bạn có chắc chắn muốn xóa người dùng "${selectedUser['username']}"?'),
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
                deleteUser(selectedUser['_id']);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addUser() async {
    final response = await http.post(
        Uri.parse('http://192.168.15.109:8000/api/users/register'),
        body: newUser);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      setState(() {
        users.add(data);
      });
      showToast('Thêm người dùng thành công');
      closeModal();
      fetchUsers();
    } else {
      showToast('Thêm người dùng thất bại');
    }
  }

  Future<void> updateUser() async {
    final response = await http.put(
        Uri.parse('http://192.168.15.109:8000/api/users/$selectedId'),
        body: newUser);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        users = users
            .map((user) => user['_id'] == selectedId ? data : user)
            .toList();
      });
      showToast('Cập nhật người dùng thành công');
      closeModal();
    } else {
      showToast('Cập nhật người dùng thất bại');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http
        .delete(Uri.parse('http://192.168.15.109:8000/api/users/$id'));
    if (response.statusCode == 200) {
      setState(() {
        users.removeWhere((user) => user['_id'] == id);
      });
      showToast('Xóa người dùng thành công');
    } else {
      showToast('Xóa người dùng thất bại');
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
      newUser['username'] = '';
      newUser['password'] = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý người dùng"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text("ID: ${user['_id']}"),
            subtitle: Text(
                "Username: ${user['username']}\nPassword: ${user['password']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => handleEdit(user['_id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => handleDelete(user['_id']),
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
      bottomSheet: showModal ? buildUserForm() : null,
    );
  }

  Widget buildUserForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedId.isNotEmpty
                ? 'Sửa thông tin người dùng'
                : 'Thêm người dùng',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(labelText: 'Username'),
            onChanged: (value) => newUser['username'] = value,
            controller: TextEditingController(text: newUser['username']),
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(labelText: 'Password'),
            onChanged: (value) => newUser['password'] = value,
            controller: TextEditingController(text: newUser['password']),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: selectedId.isNotEmpty ? updateUser : addUser,
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
