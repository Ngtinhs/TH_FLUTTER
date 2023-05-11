import 'package:demo/model/products.dart';
import 'package:flutter/material.dart';

import 'addtocart.dart';

class Body extends StatelessWidget {
  final Products product;
  const Body({Key? key, required this.product}) : super(key: key);

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
            child: Image.asset(product.image),
          ),
          const SizedBox(height: 20),
          Text(
            'Description: ${product.description}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Số lượng sản phẩm hiện có: ${product.quantity}',
            style: const TextStyle(fontSize: 16),
          ),
          AddProductToCart(
            product: product,
          ),
        ],
      ),
    );
  }
}
