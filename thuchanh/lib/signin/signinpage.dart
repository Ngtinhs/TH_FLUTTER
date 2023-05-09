import 'package:flutter/material.dart ';
import 'package:flutter/cupertino.dart';

import 'components/body.dart';

class SigninPage extends StatelessWidget {
  static String routeName= "/sign_in";

   // SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Body(),
    );
    return const Placeholder();
  }
}
