import 'package:demo/signup/components/body.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  static String routeName = "/sign_up";
   SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
        },
        ),
        centerTitle: true,
        title:  Text ("Sign Up",style: TextStyle(color:Colors.white),),
      ),
      body: Body(),
    );
  }
}
