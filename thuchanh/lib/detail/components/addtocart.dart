import 'package:demo/model/carts.dart';
import 'package:demo/model/products.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProductToCart extends StatefulWidget {
  Products product;

  AddProductToCart({super.key, required this.product});

  @override
  State<AddProductToCart> createState() => _AddProductToCartState();
}

class _AddProductToCartState extends State<AddProductToCart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          Cart cart = Cart();
          widget.product.quantity = 1;
          cart.addProductsToCart(widget.product);
          Fluttertoast.showToast(
              msg: "Add to cart",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: const MaterialStatePropertyAll(Colors.green),
        ),
        child: const Text(
          "Add to cart",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
