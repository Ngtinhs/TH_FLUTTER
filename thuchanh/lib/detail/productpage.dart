import 'package:flutter/material.dart';
import '../model/products.dart';
import 'package:demo/detail/components/body.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments? arguments =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments?;
    //

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Details"),
      ),
      body: Body(product: arguments!.product),
    );
  }
}

class ProductDetailsArguments {
  Products product;
  ProductDetailsArguments({required this.product});
}
