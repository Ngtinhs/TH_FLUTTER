import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../homepage.dart';
import '../../model/user.dart';
import '../../model/utilities.dart';
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

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _getData();
  }

  _getData() async {
    // Lấy dữ liệu từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username')!.isNotEmpty) {
      username.text = prefs.getString('username')!;
      password.text = prefs.getString('password')!;
      _value = prefs.getBool('check')!;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
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
                            // Gửi yêu cầu đăng nhập đến server
                            final url = Uri.parse(
                                'http://localhost:8000/api/users/login');
                            final response = await http.post(
                              url,
                              headers: {'Content-Type': 'application/json'},
                              body: json.encode({
                                'username': username.text,
                                'password': password.text,
                              }),
                            );

                            if (response.statusCode == 200) {
                              // Đăng nhập thành công
                              // Lưu thông tin người dùng vào SharedPreferences
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('username', username.text);
                              prefs.setString('password', password.text);
                              prefs.setBool('check', _value);

                              Navigator.pushNamed(context, HomePage.routeName);
                            } else if (response.statusCode == 401) {
                              // Tên người dùng hoặc mật khẩu không chính xác
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
                              // Xảy ra lỗi trong quá trình đăng nhập
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
                    // ...
                  ],
                ),
              ),
            ),
            // ...
          ],
        ),
      ),
    );
  }
}
