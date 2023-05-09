import 'package:flutter/cupertino.dart';

import 'home_fragment_categories.dart';
import 'home_fragment_product.dart';

class HomeDetail extends StatelessWidget {
  // const HomeDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: [CategoriesStore(), ProductPopular()],
    ));
  }
}
