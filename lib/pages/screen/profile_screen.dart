import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/cart_provider.dart';
import '../../provider/favorite_provider.dart';
import '../../service/auth_service.dart';

AuthService authService = AuthService();

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                authService.logout(context);
                ref.invalidate(favoriteProvider);
                ref.invalidate(cartProvider);
              },
              child: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }
}
