import 'package:flutter/material.dart';
import 'package:demo/cart/components/body.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  static String routeName = "/carts";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Cart Details"),
      ),
      body: const Body(),
    );
  }
}
