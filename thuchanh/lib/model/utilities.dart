import 'dart:convert';

import 'package:demo/model/products.dart';
import 'package:quiver/strings.dart';
import 'package:http/http.dart' as http;

class Utilities {
  String url = "http://192.168.15.109:8000/api/food";

  static List<Products> result = [];

  Future<List<Products>> getProducts() async {
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var content = res.body;

      print(content.toString());
      var arr = json.decode(content)['food'] as List;
      try {
        for (var element in arr) {
          var data = Products_fromJson(element);
          result.add(data);
        }
      } catch (e) {
        print(e.toString());
      }
    }
    return result;
  }

  Products_fromJson(Map<String, dynamic> item) {
    return Products(
      description: item['description'],
      title: item['title'],
      image: item['image'],
      price: double.parse(item['price']),
      id: item['_id'],
    );
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter mail';
    }

    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\'
        r']\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,'
        r'3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|((['
        r'a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 8) {
      return 'Password should be more than 8 characters';
    }
    return null;
  }

  static String? confirmPassword(String value, String value2) {
    if (!equalsIgnoreCase(value, value2)) {
      return 'Confirm Password invalid';
    }
    return null;
  }

  List<Products> find(String value) {
    return Products.init()
        .where((p) => p.title.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}
