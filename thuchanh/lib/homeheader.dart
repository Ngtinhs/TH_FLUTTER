import 'package:demo/search/searchpage.dart';
import 'package:flutter/material.dart';

import 'cart/cartpage.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onTap: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Search Product",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, CartPage.routeName);
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        )
      ],
    );
  }
}
