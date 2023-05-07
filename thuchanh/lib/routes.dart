import 'package:demo/cart/cartpage.dart';
import 'package:demo/detail/productpage.dart';
import 'package:demo/search/searchpage.dart';
import 'package:demo/signin/signinpage.dart';
import 'package:demo/signin_form/splashpage.dart';
import 'package:demo/signup/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'homepage.dart';

final Map<String, WidgetBuilder> routes = {
  SplashPage.routeName: (context) => const SplashPage(),
  SigninPage.routeName: (context) => const SigninPage(),
  SignUpPage.routeName: (context) => const SignUpPage(),
  HomePage.routeName: (context) => HomePage(),
  ProductPage.routeName: (context) => const ProductPage(),
  CartPage.routeName: (context) => const CartPage(),
  SearchPage.routeName: (context) => const SearchPage(),
};
