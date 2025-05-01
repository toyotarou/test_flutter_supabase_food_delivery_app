// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../extensions/extensions.dart';
import '../models/cart_model.dart';

final ChangeNotifierProvider<CartProvider> cartProvider = ChangeNotifierProvider<CartProvider>(
  (ChangeNotifierProviderRef<CartProvider> ref) => CartProvider(),
);

class CartProvider extends ChangeNotifier {
  CartProvider() {
    loadCart();
  }

  final SupabaseClient _supabase = Supabase.instance.client;

  List<CartItem> _items = <CartItem>[];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(
    0,
    (double sum, CartItem item) =>
        sum +
        (((item.productData['price'] != null) ? item.productData['price'].toString().toDouble() : 0) * item.quantity),
  );

  Future<void> loadCart() async {
    final String? userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return;
    }

    try {
      final PostgrestList response = await _supabase.from('cart').select().eq('user_id', userId);

      _items = (response as List).map((item) => CartItem.fromMap(item as Map<String, dynamic>)).toList();
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading cart: $e');
    }
  }

  Future<void> addCart(String productId, Map<String, dynamic> productData, int selectedQuantity) async {
    final String? userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return;
    }

    try {
      // ✅ Check if item already exists on Supabase
      final PostgrestMap? existing =
          await _supabase.from('cart').select().eq('user_id', userId).eq('product_id', productId).maybeSingle();

      if (existing != null) {
        // 🟡 Item exists → update quantity
        // ignore: avoid_dynamic_calls
        final newQuantity = (existing['quantity'] ?? 0) + selectedQuantity;

        await _supabase
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('product_id', productId)
            .eq('user_id', userId);

        // ✅ Also update in local state
        final int index = _items.indexWhere((CartItem item) => item.productId == productId && item.userId == userId);
        if (index != -1) {
          _items[index].quantity = newQuantity.toString().toInt();
        }
      } else {
        // 🆕 New item → insert
        final PostgrestList response =
            await _supabase.from('cart').insert(<String, Object>{
              'product_id': productId,
              'product_data': productData,
              'quantity': selectedQuantity,
              'user_id': userId,
            }).select();

        if (response.isNotEmpty) {
          _items.add(
            CartItem(
              id: response.first['id'].toString(),

              productId: productId,
              productData: productData,
              quantity: selectedQuantity,
              userId: userId,
            ),
          );
        }
      }

      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error in addCart: $e');
      rethrow;
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      await _supabase.from('cart').delete().eq('id', itemId);

      _items.removeWhere((CartItem item) => item.id == itemId);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error removing item: $e');
    }
  }
}
