import 'package:demo/model/user.dart';
import 'package:demo/model/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart  ';
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  // const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  var email = TextEditingController();
  final password = TextEditingController();
  final conform = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            emalTextFormField(),
            SizedBox(
              height: 30,
            ),
            passwordTextFormField(),
            SizedBox(
              height: 30,
            ),
            conformTextFormField(),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context,
                        User(username: email.text, password: conform.text));
                  }
                },
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: Text(
                  "Continue",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                      child: SvgPicture.asset("asset/icons/facebook-2.svg"),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                      child: SvgPicture.asset("asset/icons/google.svg"),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                      child: SvgPicture.asset("asset/icons/twitter.svg"),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  TextFormField emalTextFormField() {
    return TextFormField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter your email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.email_outlined)),
        // validator: Utilities.validateEmail,
        onSaved: (value) {
          setState(() {
            email.text = value!;
          });
        });
  }

  TextFormField passwordTextFormField() {
    return TextFormField(
      key: _passKey,
      controller: password,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Enter your password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.lock_outline)),
      validator: (passwordKey) {
        return Utilities.validatePassword(passwordKey!);
      },
    );
  }

  TextFormField conformTextFormField() {
    return TextFormField(
      controller: conform,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Re-enter your password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.lock_outline)),
      validator: (conformPassword) {
        var pass = _passKey.currentState?.value;
        return Utilities.confirmPassword(conformPassword!, pass);
      },
      onSaved: (value) {
        setState(() {
          conform.text = value!;
        });
      },
    );
  }
}
