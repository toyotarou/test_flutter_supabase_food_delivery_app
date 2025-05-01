import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utils/consts.dart';
import '../../models/cart_model.dart';
import '../../provider/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CartProvider cart = ref.watch(cartProvider);
    final double discountPrice = cart.totalPrice * 0.1;
    final String grandTotal = (cart.totalPrice - discountPrice + 2.99).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, forceMaterialTransparency: true, title: const Text('Your Cart')),
      body:
          cart.items.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final CartItem item = cart.items[index];
                        return Dismissible(
                          key: Key(item.id),
                          onDismissed: (_) => cart.removeItem(item.id),
                          background: Container(color: Colors.red),
                          child: ListTile(
                            leading: Image.network(item.productData['imageCard'].toString(), width: 60, height: 60),
                            title: Text(
                              item.productData['name'].toString(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text('\$${item.productData['price']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap:
                                      item.quantity > 1
                                          ? () {
                                            cart.addCart(item.productId, item.productData, -1);
                                          }
                                          : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                    ),
                                    child: const Icon(Icons.remove, size: 15, color: Colors.black),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide())),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontSize: 14.5, color: Colors.black),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => cart.addCart(item.productId, item.productData, 1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                    ),
                                    child: const Icon(Icons.add, color: Colors.black, size: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ListTile(
                          title: const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          trailing: Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const ListTile(
                          title: Text('Shipping Charge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          trailing: Text(r'(+) $2.99', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          title: const Text('Discount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          trailing: Text(
                            '(-) 10% = \$${discountPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'GrandTotal',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: red),
                          ),
                          trailing: Text(
                            '\$$grandTotal',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
