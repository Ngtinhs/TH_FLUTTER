import 'package:demo/Admin/pages/doanh_thu_page.dart';
import 'package:demo/Admin/pages/list_cate_page.dart';
import 'package:flutter/material.dart';
import './pages/list_order_page.dart';
import './pages/list_product_page.dart';
import './pages/list_user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo/signin/signinpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminPage extends StatelessWidget {
  static String routeName = "/home_admin_screen";

  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ẩn thanh quay lại :))
        title: const Text("Admin Page"),
        actions: [
          IconButton(
            onPressed: () async {
              // Xóa dữ liệu đăng nhập trong SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('username');
              prefs.remove('password');
              prefs.remove('check');

              // Chuyển về trang SignInForm
              Navigator.pushNamed(context, SigninPage.routeName);

              Fluttertoast.showToast(
                msg: 'Đăng xuất thành công',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListCategoryPage.routeName);
              },
              child: const Text("Quản lý danh mục món ăn"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListFoodPage.routeName);
              },
              child: const Text("Quản lý món ăn"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListOrderPage.routeName);
              },
              child: const Text("Quản lý đơn hàng"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListUserPage.routeName);
              },
              child: const Text("Quản lý người dùng"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, DoanhthuPage.routeName);
              },
              child: const Text("Quản lý doanh thu"),
            ),
          ],
        ),
      ),
    );
  }
}
