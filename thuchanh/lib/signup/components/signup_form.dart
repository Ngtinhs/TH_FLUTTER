import 'package:demo/signin/signinpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart  ';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  Future<void> signUp() async {
    final url = Uri.parse(
        'http://192.168.15.109:8000/api/users/register'); // Thay YOUR_REGISTER_URL bằng URL đăng ký tương ứng

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': email.text,
        'password': password.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Đăng ký thành công
      // Xử lý phản hồi từ API hoặc máy chủ (nếu cần)
      // Ví dụ: Hiển thị thông báo thành công và chuyển người dùng đến trang đăng nhập
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Đăng ký thành công'),
            content: const Text('Bạn đã đăng ký thành công.'),
            actions: [
              TextButton(
                child: const Text('Đóng'),
                onPressed: () {
                  Navigator.pop(context); // Đóng hộp thoại
                  // Chuyển đến trang đăng nhập
                  Navigator.pushNamed(context, SigninPage.routeName);
                },
              ),
            ],
          );
        },
      );
    } else {
      // Đăng ký thất bại
      // Xử lý lỗi hoặc hiển thị thông báo lỗi cho người dùng (nếu cần)
      // Ví dụ: Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Đăng ký thất bại'),
            content: const Text('Đã xảy ra lỗi trong quá trình đăng ký.'),
            actions: [
              TextButton(
                child: const Text('Đóng'),
                onPressed: () {
                  Navigator.pop(context); // Đóng hộp thoại
                },
              ),
            ],
          );
        },
      );
    }
  }

  var email = TextEditingController();
  final password = TextEditingController();
  final conform = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            emailTextFormField(),
            const SizedBox(
              height: 30,
            ),
            passwordTextFormField(),
            const SizedBox(
              height: 30,
            ),
            conformTextFormField(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signUp(); // Gọi phương thức signUp() khi người dùng nhấn nút "Continue"
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.green),
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
              height: 30,
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
                          color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                      child: SvgPicture.asset("asset/icons/facebook-2.svg"),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                      child: SvgPicture.asset("asset/icons/google.svg"),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
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

  TextFormField emailTextFormField() {
    return TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  TextFormField passwordTextFormField() {
    return TextFormField(
      key: _passKey,
      controller: password,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  TextFormField conformTextFormField() {
    return TextFormField(
      controller: conform,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please re-enter your password';
        }
        return null;
      },
    );
  }
}
