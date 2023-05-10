import 'package:flutter/material.dart';
import '../../model/carts.dart';
import '../../model/products.dart';
import 'package:demo/cart/components/checkoutcart.dart';
import 'package:demo/model/utilities.dart' as Utils;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Products> cartdetail = Cart().getCart();
  double sum = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() {
    sum = 0.0;
    cartdetail.forEach((product) {
      sum += product.price * product.quantity; // Tính tổng giá trị đơn hàng
    });
  }

  Future<void> updateQuantity(int index, int quantity) async {
    final product = cartdetail[index];

    // Lấy danh sách sản phẩm từ server
    final productList = await Utils.Utilities().getProducts();

    // Tìm sản phẩm tương ứng trong danh sách
    final matchedProduct = productList.firstWhere(
      (p) => p.id == product.id,
      orElse: () => Products(
          id: '',
          description: '',
          image: '',
          title: '',
          price: 0.0,
          quantity: 0), // Đối tượng mặc định
    );

    if (matchedProduct.id.isNotEmpty) {
      // Kiểm tra số lượng sản phẩm hiện có trên server
      if (matchedProduct.quantity >= product.quantity + quantity) {
        setState(() {
          product.quantity += quantity; // Cập nhật số lượng sản phẩm

          if (product.quantity < 1) {
            cartdetail.removeAt(index); // Xóa sản phẩm nếu số lượng nhỏ hơn 1
          }

          calculateTotal(); // Cập nhật tổng giá trị đơn hàng sau khi thay đổi số lượng
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Vượt quá số lượng sản phẩm hiện có"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không tìm thấy sản phẩm trên server"),
        ),
      );
    }
  }

  void removeProduct(int index) {
    setState(() {
      cartdetail.removeAt(index); // Xóa sản phẩm khỏi giỏ hàng
      calculateTotal(); // Cập nhật tổng giá trị đơn hàng sau khi xóa sản phẩm
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartdetail.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        child: CartItem(
                          product: cartdetail[index],
                          onQuantityChanged: (quantity) {
                            updateQuantity(index,
                                quantity); // Gọi hàm cập nhật số lượng sản phẩm
                          },
                          onRemove: () {
                            removeProduct(index); // Gọi hàm xóa sản phẩm
                          },
                        ),
                        onTap: () {
                          setState(() {
                            cartdetail.removeAt(index);
                            calculateTotal();
                          });
                        },
                      ),
                      const Divider()
                    ],
                  );
                }),
          ),
          CheckOutCart(
            products: cartdetail,
            sum: sum,
          )
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  Products product;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  CartItem(
      {Key? key,
      required this.product,
      required this.onQuantityChanged,
      required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(width: 100, height: 100, child: Image.asset(product.image)),
          Expanded(child: Text(product.title)),
          Expanded(child: Text(product.price.toString())),
          QuantityButton(
            quantity: product.quantity,
            onIncrease: () {
              onQuantityChanged(1); // Tăng số lượng sản phẩm lên 1
            },
            onDecrease: () {
              onQuantityChanged(-1); // Giảm số lượng sản phẩm đi 1
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onRemove, // Xóa sản phẩm
          ),
        ],
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantityButton({
    Key? key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: onDecrease, // Giảm số lượng
        ),
        Text(quantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onIncrease, // Tăng số lượng
        ),
      ],
    );
  }
}
