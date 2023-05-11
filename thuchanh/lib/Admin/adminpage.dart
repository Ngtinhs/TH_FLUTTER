import 'package:demo/Admin/pages/list_cate_page.dart';
import 'package:flutter/material.dart';
import './pages/list_order_page.dart';
import './pages/list_product_page.dart';
import './pages/list_user_page.dart';

class AdminPage extends StatelessWidget {
  static String routeName = "/home_admin_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, FoodList.routeName);
              },
              child: Text("Quản lý sản phẩm"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListUserPage.routeName);
              },
              child: Text("Quản lý người dùng"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListOrderPage.routeName);
              },
              child: Text("Quản lý đơn hàng"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListCategoryPage.routeName);
              },
              child: Text("Quản lý danh mục sp"),
            ),
          ],
        ),
      ),
    );
  }
}
