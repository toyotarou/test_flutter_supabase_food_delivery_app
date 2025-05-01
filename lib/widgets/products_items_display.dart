import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Utils/consts.dart';
import '../models/product_model.dart';
import '../pages/screen/food_detail_screeen.dart';
import '../provider/favorite_provider.dart';

class ProductsItemsDisplay extends ConsumerWidget {
  const ProductsItemsDisplay({super.key, required this.foodModel});

  final FoodModel foodModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FavoriteProvider provider = ref.watch(favoriteProvider);
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          // ignore: inference_failure_on_instance_creation, always_specify_types
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (_, __, ___) => FoodDetailScreen(product: foodModel),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            bottom: 35,
            child: Container(
              height: 180,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withAlpha(10), spreadRadius: 10, blurRadius: 20)],
              ),
            ),
          ),
          // for hot or favorite icon
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                ref.read(favoriteProvider).toggleFavorite(foodModel.name);
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: provider.isExist(foodModel.name) ? Colors.red[100] : Colors.transparent,
                child:
                    provider.isExist(foodModel.name)
                        ? Image.asset('assets/food-delivery/icon/fire.png', height: 22)
                        : const Icon(Icons.local_fire_department, color: red),
              ),
            ),
          ),
          Container(
            width: size.width * 0.5,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Hero(
                  tag: foodModel.imageCard,
                  child: Image.network(foodModel.imageCard, height: 140, width: 150, fit: BoxFit.fill),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    foodModel.name,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Text(
                  foodModel.specialItems,
                  style: const TextStyle(height: 0.1, letterSpacing: 0.5, fontSize: 15, color: Colors.black),
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: <InlineSpan>[
                      const TextSpan(text: r'$', style: TextStyle(fontSize: 14, color: red)),
                      TextSpan(text: '${foodModel.price}', style: const TextStyle(fontSize: 25, color: Colors.black)),
                    ],
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
