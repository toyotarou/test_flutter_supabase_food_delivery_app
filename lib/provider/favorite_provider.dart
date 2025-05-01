// add the flutter riverpod apackage for state management
// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final ChangeNotifierProvider<FavoriteProvider> favoriteProvider = ChangeNotifierProvider<FavoriteProvider>(
  (ChangeNotifierProviderRef<FavoriteProvider> ref) => FavoriteProvider(),
);

class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider() {
    // load the favorite provider
    loadFavorites();
  }

  List<String> _favoriteIds = <String>[];
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  List<String> get favorite => _favoriteIds;

  String? get userId => _supabaseClient.auth.currentUser?.id;

  void reset() {
    _favoriteIds = <String>[];
    notifyListeners();
  }

  // Toggle favorite state
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      // remove favorite
      await _removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      // add favorite
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  // check if product is favorite
  bool isExist(String productId) {
    return _favoriteIds.contains(productId);
  }

  // add favorite to supabase
  Future<void> _addFavorite(String productId) async {
    if (userId == null) {
      return;
    }
    try {
      await _supabaseClient.from('favorites').insert(<String, String?>{
        // let's create a favorite table in supabase
        'user_id': userId,
        'product_id': productId,
      });
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // remove favorite from supabase
  Future<void> _removeFavorite(String productId) async {
    if (userId == null) {
      return;
    }
    try {
      await _supabaseClient.from('favorites').delete().match(<String, Object>{
        'user_id': userId!,
        'product_id': productId,
      });
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Load favorite from supabase
  Future<void> loadFavorites() async {
    if (userId == null) {
      return;
    }
    try {
      final PostgrestList data = await _supabaseClient.from('favorites').select('product_id').eq('user_id', userId!);
      _favoriteIds = data.map<String>((PostgrestMap row) => row['product_id'] as String).toList();
    } catch (e) {
      print('Error loadin favorite $e');
    }
    notifyListeners();
  }
}
