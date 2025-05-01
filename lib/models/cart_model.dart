// cart model
import '../extensions/extensions.dart';

class CartItem {

  CartItem({
    required this.id,
    required this.productId,
    required this.productData,
    required this.quantity,
    required this.userId,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'].toString(),
      productId: map['product_id'].toString(),
      productData: Map<String, dynamic>.from(map['product_data'] as Map<dynamic, dynamic>),
      quantity: (map['quantity'] != null) ? map['quantity'].toString().toInt() : 0,
      userId: map['user_id'].toString(),
    );
  }
  final String id;
  final String productId;
  final Map<String, dynamic> productData;
  int quantity;
  final String userId;
}
