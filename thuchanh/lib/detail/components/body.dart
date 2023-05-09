import 'package:demo/model/products.dart';
import 'package:flutter/material.dart';

import 'addtocart.dart';

class Body extends StatelessWidget {
  final Products product;
  const Body({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.asset(product.image)),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Text("Description: ${product.description}"),
            flex: 1,
          ),
          AddProductToCart(
            product: product,
          )
        ],
      ),
    );
  }
}
