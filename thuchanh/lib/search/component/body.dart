import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:demo/model/products.dart';
import 'package:demo/model/utilities.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  List<Products> dataProduct = <Products>[];

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Products> productsResul = <Products>[];
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    print('class này đã chạy');
    loadProducts();
  }

  Future<void> loadProducts() async {
    List<Products> products = await Utilities().getProducts();
    setState(() {
      widget.dataProduct = products;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: buildRow(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Điều hướng trở lại trang trước đó
          },
        ),
      ),
      body: buildContainer(context),
    );
  }

  Widget buildRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Search product",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                Fluttertoast.showToast(
                  msg: value.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                if (value.isEmpty) {
                  widget.dataProduct = <Products>[];
                  return;
                }
                widget.dataProduct = Utilities().find(value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildContainer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.dataProduct.isEmpty)
            const Expanded(child: Center(child: Text("No item")))
          else
            Expanded(
              child: ListView.builder(
                itemCount: widget.dataProduct.length,
                itemBuilder: (context, index) {
                  return ProductItemList(
                    product: widget.dataProduct[index],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ProductItemList extends StatelessWidget {
  final Products product;

  const ProductItemList({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement your product item list widget here
    // Return a widget to display the product item
    return ListTile(
      title: Text(product.title),
      subtitle: Text(product.description),
      leading: Image.network(product.image),
      trailing: Text(product.price.toString()),
    );
  }
}
