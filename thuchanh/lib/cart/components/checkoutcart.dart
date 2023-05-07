import 'dart:convert';
import 'package:demo/homepage.dart';
import 'package:demo/model/carts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:demo/model/products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckOutCart extends StatelessWidget {
  final double sum;
  final List<Products> products;
  const CheckOutCart({super.key, required this.sum, required this.products});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: const BorderSide(color: Colors.green))),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
              side: const MaterialStatePropertyAll(
                  BorderSide(color: Colors.green)),
              iconSize: const MaterialStatePropertyAll(
                50,
              ),
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
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0))),
              side: const MaterialStatePropertyAll(
                  BorderSide(color: Colors.green)),
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

  void _checkOut(BuildContext context) {
    print('checking out');
    postRequest();
    Fluttertoast.showToast(
        msg: "Checkout to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Cart cart = Cart();
    cart.clearProductsInCart();
    Navigator.pushNamedAndRemoveUntil(
        context, HomePage.routeName, (Route<dynamic> route) => false);
  }

  Future<void> postRequest() async {
    var url = 'http://10.0.2.2:8000/api/orders/checkout';
    var data = {
      "username": "Nguyenvanductinh@gmail.com",
      "address": "16 Chử Đồng Tử",
      "orderDetails": products.map((e) => toJson(e)).toList(),
      "status": "unpaid",
      "total": sum
    };
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        body: body, headers: {'Content-Type': 'application/json'});
    print(response.body);
  }

  Map<String, dynamic> toJson(Products product) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = product.title;
    data['image'] = product.image;
    data['price'] = product.price;
    data['description'] = product.description;
    return data;
  }

  Products_fromJson(Map<String, dynamic> item) {
    return Products(
      description: item['description'],
      title: item['title'],
      image: item['image'],
      price: double.parse(item['price']),
      id: item['_id'],
    );
  }
}
