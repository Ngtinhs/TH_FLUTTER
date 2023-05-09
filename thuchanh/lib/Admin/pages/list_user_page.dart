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
          );
        },
      ),
    );
  }
}
