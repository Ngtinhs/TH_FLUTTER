import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListOrderPage extends StatefulWidget {
  static String routeName = "/list_order_screen";

  @override
  _ListOrderPageState createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response =
        await http.get(Uri.parse('http://192.168.15.109:8000/api/orders'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        orders = data['orders'];
      });
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách đơn hàng"),
      ),
      body: Container(
        child: orders.length > 0
            ? ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text("Username: ${order['username']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address: ${order['address']}"),
                        Text("Total: ${order['total']}"),
                        Text("Status: ${order['status']}"),
                        Text("Details:"),
                        order['orderDetails'] != null
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: order['orderDetails'].length,
                                itemBuilder: (context, idx) {
                                  final product = order['orderDetails'][idx];
                                  return ListTile(
                                    title: Text("Title: ${product['title']}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Description: ${product['description']}"),
                                        Text("Price: ${product['price']}"),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Text("No order details available."),
                      ],
                    ),
                  );
                },
              )
            : Center(child: Text("No orders available.")),
      ),
    );
  }
}
