import 'package:demo/cart/cartpage.dart';
import 'package:demo/detail/productpage.dart';
import 'package:demo/search/searchpage.dart';
import 'package:demo/signin/signinpage.dart';
import 'package:demo/signin_form/splashpage.dart';
import 'package:demo/signup/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'homepage.dart';
import 'Admin/adminpage.dart';
import './Admin/pages/list_user_page.dart';
import './Admin/pages/list_product_page.dart';
import './Admin/pages/list_order_page.dart';

final Map<String, WidgetBuilder> routes = {
  SplashPage.routeName: (context) => SplashPage(),
  SigninPage.routeName: (context) => SigninPage(),
  SignUpPage.routeName: (context) => SignUpPage(),
  HomePage.routeName: (context) => HomePage(),
  AdminPage.routeName: (context) => AdminPage(),
  ProductPage.routeName: (context) => ProductPage(),
  CartPage.routeName: (context) => CartPage(),
  SearchPage.routeName: (context) => SearchPage(),
  ListUserPage.routeName: (context) => ListUserPage(),
  FoodList.routeName: (context) => FoodList(),
  ListOrderPage.routeName: (context) => ListOrderPage(),
};
