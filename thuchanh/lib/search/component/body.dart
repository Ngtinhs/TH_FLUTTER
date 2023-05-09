import 'package:demo/homepage/components/fragment/favorit_fragment.dart';
import 'package:demo/model/products.dart';
import 'package:demo/model/utilities.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_tags/simple_tags.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  List<Products> dataProduct = <Products>[];

  List<String> tags = ["food", "categories", "bread"];

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Products> products = Products.init();
  List<Products> productsResul = <Products>[];
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    print('class nay da chay');
  }

  Widget buildTag(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recommend"),
          SimpleTags(
            content: widget.tags,
            wrapSpacing: 4,
            wrapRunSpacing: 4,
            onTagPress: (tag) {
              print(Utilities().find(tag));
              setState(() {
                widget.dataProduct.clear();
                widget.dataProduct.addAll(Utilities().find(tag));
              });
              print(tag);
              print(widget.dataProduct);
            },
            tagContainerDecoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: buildRow(),
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
                prefixIcon: Icon(Icons.search)),
            onChanged: (value) {
              setState(() {
                Fluttertoast.showToast(
                    msg: value.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                if (value.isEmpty) {
                  widget.dataProduct = <Products>[];
                  return;
                }
                widget.dataProduct.clear();
                widget.dataProduct.addAll(Utilities().find(value));
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
          buildTag(context),
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
                    }))
        ],
      ),
    );
  }
}
