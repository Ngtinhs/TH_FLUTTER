import 'package:flutter/cupertino.dart';
import 'homepage/components/body.dart';

class HomePage extends StatelessWidget {
  int selectIndex = 0;
  static String routeName = "/home_screen";

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
