import 'package:demo/signup/components/signup_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
   // Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Register Account",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  height: 1.5),
            ),
            Text(
              "Complete your details or continue \nwith social media",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF4caf50)),
            ),
            SignUpForm()
          ],
        ),
      ),
    ));
  }
}
