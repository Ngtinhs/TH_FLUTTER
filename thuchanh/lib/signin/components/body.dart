import 'package:flutter/cupertino.dart';
import 'package:demo/signin/components/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:demo/model/user.dart';
import '../../homeheader.dart';
import '../../menuheader.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            headerScreen(context),
            const SignInForm(),
            footerScreen(context),
          ],
        ),
      ),
    ));

    return const Placeholder();
  }

  Widget headerScreen(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      alignment: Alignment.bottomRight,
      child: Image.asset("asset/images/dish.png"),
    );
  }

  Widget footerScreen(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomLeft,
      child: Image.asset("asset/images/dish_2.png"),
    );
  }
}
