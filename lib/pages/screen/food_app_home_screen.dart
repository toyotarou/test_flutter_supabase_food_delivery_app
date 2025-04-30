import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Utils/consts.dart';
import '../../models/categories_model.dart';

class FoodAppHomeScreen extends StatefulWidget {
  const FoodAppHomeScreen({super.key});

  @override
  State<FoodAppHomeScreen> createState() => _FoodAppHomeScreenState();
}

class _FoodAppHomeScreenState extends State<FoodAppHomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();

  List<CategoryModel> categories = <CategoryModel>[];

  String? selectedCategory;

  ///
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final PostgrestList response = await Supabase.instance.client.from('category_items').select();

      // ignore: always_specify_types
      return (response as List).map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (error) {
      // ignore: avoid_print
      print('Error fetching categories: $error');
      return <CategoryModel>[];
    }
  }

  ///
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  ///
  Future<void> _initializeData() async {
    try {
      final List<CategoryModel> categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          this.categories = categories;
          selectedCategory = categories.first.name;
          // // fetch food products
          // futureFoodProducts = fetchFoodProduct(selectedCategory!);
          //
          //
          //
          //
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print(' Initialization error: $error');
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          const SizedBox(width: 25),

          Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: grey1, borderRadius: BorderRadius.circular(10)),

            child: Image.asset('assets/food-delivery/icon/dash.png'),
          ),

          const Spacer(),

          const Row(
            children: <Widget>[
              Icon(Icons.location_on_outlined, size: 18, color: red),
              SizedBox(width: 5),
              Text(
                'Kathmandu, Nepal',

                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
              ),

              SizedBox(width: 5),
              Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: orange),
            ],
          ),

          const Spacer(),

          Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: grey1, borderRadius: BorderRadius.circular(10)),

            child: Image.asset('assets/food-delivery/profile.png'),
          ),

          const SizedBox(width: 25),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 160,
                  decoration: BoxDecoration(color: imageBackground, borderRadius: BorderRadius.circular(20)),

                  padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                children: <InlineSpan>[
                                  TextSpan(text: 'The Fastest In Delivery ', style: TextStyle(color: Colors.black)),
                                  TextSpan(text: 'Food', style: TextStyle(color: red)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            Container(
                              decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                              child: const Text('Order Now', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),

                      Image.asset('assets/food-delivery/courier.png'),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          _buildCategoryList(),
        ],
      ),
    );
  }

  ///
  Widget _buildCategoryList() {
    // ignore: always_specify_types
    return FutureBuilder(
      future: futureCategories,
      builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 60,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final CategoryModel category = categories[index];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15),
                child: GestureDetector(
                  onTap: () => handelCategoryTap(category.name),

                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == category.name ? red : grey1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedCategory == category.name ? Colors.white : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            category.image,
                            width: 20,
                            height: 20,
                            errorBuilder:
                                (BuildContext context, Object error, StackTrace? stackTrace) =>
                                    const Icon(Icons.fastfood),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: selectedCategory == category.name ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  ///
  void handelCategoryTap(String category) {
    if (selectedCategory == category) {
      return;
    }

    setState(() {
      selectedCategory = category;
      // // fetch food products
      // futureFoodProducts = fetchFoodProduct(category);
      //
      //
      //
      //
    });
  }
}
