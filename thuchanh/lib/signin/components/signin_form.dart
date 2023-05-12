import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../homepage.dart';
import '../../model/utilities.dart';
import 'package:flutter_svg/svg.dart';
import '../../Admin/adminpage.dart';
import '../../signup/signup_page.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool _value = false;
  var result;

  late FToast fToast;

  final username = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final image = TextEditingController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _getData();
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username')?.isNotEmpty ?? false) {
      setState(() {
        username.text = prefs.getString('username') ?? '';
        password.text = prefs.getString('password') ?? '';
        fullname.text = prefs.getString('fullname') ?? '';
        image.text = prefs.getString('image') ?? '';
        _value = prefs.getBool('check') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Food Now",
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sign in with your email and password \nor continue with social media",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      validator: (value) {
                        return Utilities.validatePassword(value!);
                      },
                      onSaved: (value) {
                        setState(() {
                          username.text = value!;
                        });
                      },
                      controller: username,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Username",
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: password,
                      validator: (value) {
                        return Utilities.validatePassword(value!);
                      },
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final url = Uri.parse(
                                'http://192.168.15.109:8000/api/users/login');
                            final response = await http.post(
                              url,
                              headers: {'Content-Type': 'application/json'},
                              body: json.encode({
                                'username': username.text,
                                'password': password.text,
                              }),
                            );
                            if (response.statusCode == 200) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('username', username.text);
                              prefs.setString('password', password.text);
                              prefs.setString('fullname', fullname.text);
                              prefs.setString('image', image.text);
                              prefs.setBool('check', _value);

                              var userData = json.decode(response.body);
                              var role = userData['role'];
                              print('Check role: $role');
                              print('Check response: ${response.body}');

                              if (role == 'admin') {
                                Navigator.pushNamed(
                                    context, AdminPage.routeName);
                              } else {
                                Navigator.pushNamed(
                                    context, HomePage.routeName);
                              }
                            } else if (response.statusCode == 401) {
                              final responseData = json.decode(response.body);
                              final message = responseData['message'];

                              Fluttertoast.showToast(
                                msg: message,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Đã xảy ra lỗi trong quá trình đăng nhập',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.green),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xFFF5F6F9),
                                shape: BoxShape.circle),
                            child:
                                SvgPicture.asset("asset/icons/facebook-2.svg"),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xFFF5F6F9),
                                shape: BoxShape.circle),
                            child: SvgPicture.asset("asset/icons/google.svg"),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xFFF5F6F9),
                                shape: BoxShape.circle),
                            child: SvgPicture.asset("asset/icons/twitter.svg"),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account ?",
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                        GestureDetector(
                            onTap: () async {
                              // Navigator.pushNamed(
                              //     context, SignUpPage.routeName);
                              result = await Navigator.pushNamed(
                                  context, SignUpPage.routeName);
                              // User user = result;
                              // username.text = user.username!;
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 14),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
