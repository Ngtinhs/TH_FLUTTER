import 'package:flutter/material.dart';

import 'components/body.dart';

class SigninPage extends StatelessWidget {
  static String routeName = "/sign_in";

  const SigninPage({super.key});

  // SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: SignInForm(),
    );
    return const Placeholder();
  }
}
