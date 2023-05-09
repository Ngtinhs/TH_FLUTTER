import 'package:demo/model/products.dart';
import 'package:demo/model/utilities.dart';
import 'package:flutter/material.dart';

import '../../../detail/productpage.dart';

class ProductPopular extends StatefulWidget {
  const ProductPopular({super.key});

  @override
  State<ProductPopular> createState() => _ProductPopularState();
}

class _ProductPopularState extends State<ProductPopular> {
  late Future<List<Products>> future;

  @override
  void initState() {
    future = Utilities().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: const [
              Expanded(
                  child: Text(
                'Popular Products',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              )),
              Text(
                'See more',
                style: TextStyle(fontSize: 16, color: Colors.lightGreen),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        product: snapshot.data![index],
                      );
                    });
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  Products product;

  ProductItem({super.key, required this.product});

  // const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utilities.result.add(product);
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: ProductDetailsArguments(product: product));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            product.image,
            fit: BoxFit.fill,
          ),
          Row(
            children: [
              Expanded(child: Text(product.title)),
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.green),
                  child: Text(
                    product.price.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
