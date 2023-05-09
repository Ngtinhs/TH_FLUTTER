import 'package:flutter/material.dart';

class ListOrderPage extends StatelessWidget {
  static String routeName = "/list_order_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý người dùng"),
      ),
      body: Center(
        child: Text("Danh sách người dùng"),
      ),
    );
  }
}
