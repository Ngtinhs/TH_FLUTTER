import 'package:demo/search/component/body.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static String routeName = "/search_screen";
  @override
  Widget build(BuildContext context) {
    return Body();
  }
}
