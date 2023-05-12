import 'package:demo/Admin/pages/doanh_thu_page.dart';
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
import 'package:demo/Admin/pages/list_cate_page.dart';

final Map<String, WidgetBuilder> routes = {
  SplashPage.routeName: (context) => const SplashPage(),
  SigninPage.routeName: (context) => const SigninPage(),
  SignUpPage.routeName: (context) => const SignUpPage(),
  HomePage.routeName: (context) => HomePage(),
  AdminPage.routeName: (context) => const AdminPage(),
  ProductPage.routeName: (context) => const ProductPage(),
  CartPage.routeName: (context) => const CartPage(),
  SearchPage.routeName: (context) => const SearchPage(),
  ListUserPage.routeName: (context) => const ListUserPage(),
  ListFoodPage.routeName: (context) => const ListFoodPage(),
  ListOrderPage.routeName: (context) => const ListOrderPage(),
  ListCategoryPage.routeName: (context) => const ListCategoryPage(),
  DoanhthuPage.routeName: (context) => const DoanhthuPage(),
};
