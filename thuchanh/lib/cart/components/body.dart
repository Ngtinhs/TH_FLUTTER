import 'package:flutter/material.dart';
import '../../model/carts.dart';
import '../../model/products.dart';
import 'package:demo/cart/components/checkoutcart.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Products> cartdetail = Cart().getCart();
  double sum = 0.0;

  @override
  void initState() {
    super.initState();
    cartdetail.forEach((product) {
      sum = sum + product.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartdetail.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        child: CartItem(
                          product: cartdetail[index],
                        ),
                        onTap: () {
                          setState(() {
                            cartdetail.removeAt(index);
                            sum = 0.0;
                            cartdetail.forEach((product) {
                              sum = sum + product.price;
                            });
                          });
                        },
                      ),
                      const Divider()
                    ],
                  );
                }),
          ),
          CheckOutCart(
            products: cartdetail,
            sum: sum,
          )
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  // const CartItem({Key? key}) : super(key: key);
  Products product;
  CartItem({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(width: 100, height: 100, child: Image.asset(product.image)),
          Expanded(child: Text(product.title)),
          Expanded(child: Text(product.price.toString())),
          const Icon(Icons.delete_outline)
        ],
      ),
    );
  }
}
