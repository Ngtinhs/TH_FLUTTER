import 'package:flutter/material.dart';

class Categories {
  int id;
  String title;
  String image;

  Categories({required this.id, required this.title, required this.image});

  static List<Categories> init() {
    List<Categories> data = [
      Categories(
          id: 1, title: "HighLand", image: "asset/images/ic_highland.jpeg"),
      Categories(id: 2, title: "CircleK", image: "asset/images/ic_circlek.png"),
      Categories(
          id: 3, title: "MiniStop", image: "asset/images/ic_ministop.png"),
      Categories(
          id: 4,
          title: "SevenEleven",
          image: "asset/images/ic_seveneleven.png"),
      Categories(id: 5, title: "Vinmart", image: "asset/images/ic_vinmart.png")
    ];
    return data;
  }
}
