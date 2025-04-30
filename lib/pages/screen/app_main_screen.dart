import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../Utils/consts.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'food_app_home_screen.dart';
import 'profile_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentIndex = 0;
  final List<Widget> _pages = <Widget>[
    const FoodAppHomeScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
    const CartScreen(),
  ];

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],

      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNavItems(Iconsax.home_15, 'A', 0),
            const SizedBox(width: 10),
            _buildNavItems(Iconsax.heart, 'B', 1),
            const SizedBox(width: 90),
            _buildNavItems(Icons.person_outline, 'C', 2),
            const SizedBox(width: 15),

            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                _buildNavItems(Iconsax.shopping_cart, 'D', 3),
                const Positioned(
                  right: -7,
                  top: 16,
                  // we well make this number of cart items dynamic later
                  child: CircleAvatar(
                    backgroundColor: red,
                    radius: 10,
                    child: CircleAvatar(
                      backgroundColor: red,
                      child: Text('0', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
                ),
                const Positioned(
                  right: 155,
                  top: -25,
                  child: CircleAvatar(
                    backgroundColor: red,
                    radius: 35,
                    child: Icon(CupertinoIcons.search, size: 35, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget _buildNavItems(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 28, color: currentIndex == index ? red : Colors.grey),
          const SizedBox(height: 3),
          CircleAvatar(radius: 3, backgroundColor: currentIndex == index ? red : Colors.transparent),
        ],
      ),
    );
  }
}
