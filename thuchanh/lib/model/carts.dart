import 'products.dart';

class Cart {
  static List<Products> cart = [];
  void addProductsToCart(Products product) {
    cart.add(product);
  }

  void clearProductsInCart() {
    cart.clear();
  }

  List<Products> getCart() {
    return cart;
  }
}
