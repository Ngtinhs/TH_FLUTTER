import 'package:flutter/material.dart';
import '../../../detail/productpage.dart';
import 'package:demo/model/products.dart';
import 'package:demo/model/utilities.dart';

class ProductPopular extends StatefulWidget {
  const ProductPopular({Key? key}) : super(key: key);

  @override
  State<ProductPopular> createState() => _ProductPopularState();
}

class _ProductPopularState extends State<ProductPopular> {
  late Future<List<Products>> future;
  List<Products> currentData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    final data = await Utilities().getProducts();

    setState(() {
      currentData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Popular Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.lightGreen,
                ),
                onPressed: isLoading ? null : loadData,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (currentData.isEmpty)
            isLoading ? const CircularProgressIndicator() : Container()
          else
            GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: currentData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                return ProductItem(
                  product: currentData[index],
                );
              },
            ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Products product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utilities.result.add(product);
        Navigator.pushNamed(
          context,
          ProductPage.routeName,
          arguments: ProductDetailsArguments(product: product),
        );
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
                  color: Colors.green,
                ),
                child: Text(
                  product.price.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
