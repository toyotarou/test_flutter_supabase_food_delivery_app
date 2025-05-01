import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/product_model.dart';
import '../../provider/favorite_provider.dart';

final SupabaseClient supabase = Supabase.instance.client;

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final String? userId = supabase.auth.currentUser?.id;
    final FavoriteProvider provider = ref.watch(favoriteProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body:
          userId == null
              ? const Center(child: Text('Please login to vew favorites'))
              : StreamBuilder<List<Map<String, dynamic>>>(
                stream: supabase
                    .from('favorites')
                    .stream(primaryKey: <String>['id'])
                    .eq('user_id', userId)
                    .map((SupabaseStreamEvent data) => data.cast<Map<String, dynamic>>()),
                builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final List<Map<String, dynamic>> favorites = snapshot.data!;
                  if (favorites.isEmpty) {
                    return const Center(child: Text('No favorites yet'));
                  }
                  // ignore: always_specify_types
                  return FutureBuilder(
                    future: _fetchFavoriteItems(favorites),
                    builder: (BuildContext context, AsyncSnapshot<List<FoodModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final List<FoodModel> favoritesItems = snapshot.data!;
                      if (favoritesItems.isEmpty) {
                        return const Center(child: Text('No favorites yet'));
                      }
                      return ListView.builder(
                        itemCount: favoritesItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final FoodModel items = favoritesItems[index];
                          return Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: NetworkImage(items.imageCard),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 20),
                                              child: Text(
                                                items.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                                              ),
                                            ),
                                            Text(items.category),
                                            Text(
                                              '\$${items.price}.00',
                                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.pink),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                right: 35,
                                child: GestureDetector(
                                  onTap: () {
                                    provider.toggleFavorite(items.name);
                                  },
                                  child: const Icon(Icons.delete, color: Colors.red, size: 25),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
    );
  }

  Future<List<FoodModel>> _fetchFavoriteItems(List<Map<String, dynamic>> favorites) async {
    final List<String> productNames =
        favorites.map((Map<String, dynamic> fav) => fav['product_id'].toString()).toList();
    if (productNames.isEmpty) {
      return <FoodModel>[];
    }

    try {
      final PostgrestList response = await supabase.from('food_products').select().inFilter('name', productNames);
      if (response.isEmpty) {
        return <FoodModel>[];
      }
      return response.map((PostgrestMap data) => FoodModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching favorite items:$e');
      return <FoodModel>[];
    }
  }
}
