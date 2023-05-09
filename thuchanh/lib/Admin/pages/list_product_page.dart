import 'package:flutter/material.dart';

class ListProductPage extends StatelessWidget {
  static String routeName = "/list_product_screen";

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
