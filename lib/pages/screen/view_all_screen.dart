import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/product_model.dart';
import '../../widgets/products_items_display.dart';

class ViewAllProductScreen extends StatefulWidget {
  const ViewAllProductScreen({super.key});

  @override
  State<ViewAllProductScreen> createState() => _ViewAllProductScreenState();
}

class _ViewAllProductScreenState extends State<ViewAllProductScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<FoodModel> products = <FoodModel>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFoodProduct();
  }

  // to fetch product data from supabase
  Future<void> fetchFoodProduct() async {
    try {
      final PostgrestList response = await Supabase.instance.client.from('food_products').select();
      // ignore: strict_raw_type, always_specify_types
      final List data = response as List;

      setState(() {
        // ignore: always_specify_types
        products = data.map((json) => FoodModel.fromJson(json as Map<String, dynamic>)).toList();
        isLoading = false;
      });
    } catch (error) {
      // ignore: avoid_print
      print('Error fetching Product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('All Products'),

        backgroundColor: Colors.blue[50],
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                itemCount: products.length,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // two items per row
                  childAspectRatio: 0.59,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ProductsItemsDisplay(foodModel: products[index]);
                },
              ),
    );
  }
}
