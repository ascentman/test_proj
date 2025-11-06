import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.priceValue * quantity;

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'count': quantity,
      'price': product.price,
    };
  }
}
