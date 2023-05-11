import 'dart:convert';
import 'package:demo/homepage.dart';
import 'package:demo/model/carts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:demo/model/products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutCart extends StatelessWidget {
  final double sum;
  final List<Products> products;
  const CheckOutCart({Key? key, required this.sum, required this.products})
      : super(key: key);

  Future<void> _checkOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    var data = {
      "username": username,
      // "address": "16 Chử đồng tử",
      "orderDetails": products.map((e) => ProductUtils.toJson(e)).toList(),
      "status": "unpaid",
      "total": sum
    };

    final url = Uri.parse('http://192.168.15.109:8000/api/orders/checkout');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Đặt hàng thành công!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Giảm số lượng sản phẩm
      for (int i = 0; i < products.length; i++) {
        products[i].quantity -= 1;
      }

      // Xóa sản phẩm có số lượng <= 0
      products.removeWhere((product) => product.quantity <= 0);

      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (route) => false,
      );
    } else {
      // Xử lý khi đặt hàng thất bại
      Fluttertoast.showToast(
        msg: 'Đã xảy ra lỗi trong quá trình đặt hàng',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: const BorderSide(color: Colors.green))),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.green)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
            ),
            onPressed: () {},
            child: Text(
              "Sum:$sum",
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0))),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.green)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
            ),
            onPressed: () {
              _checkOut(context);
            },
            child: Text("Check out".toUpperCase(),
                style: const TextStyle(fontSize: 14)),
          ),
        )
      ],
    );
  }
}

class ProductUtils {
  static Map<String, dynamic> toJson(Products product) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = product.title;
    data['image'] = product.image;
    data['price'] = product.price;
    data['description'] = product.description;
    return data;
  }
}
