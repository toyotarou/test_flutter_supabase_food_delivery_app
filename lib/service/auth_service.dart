import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/auth/login_screen.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  ///
  Future<String?> signup(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(password: password, email: email);

      if (response.user != null) {
        return null; // indicates sucess
      }

      return 'An unknow error occurred';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error:$e';
    }
  }

  ///
  Future<String?> login(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(password: password, email: email);

      if (response.user != null) {
        return null; // indicates sucess
      }

      return 'Invalid email or password';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error:$e';
    }
  }

  ///
  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();

      if (!context.mounted) {
        return;
      }

      // ignore: inference_failure_on_instance_creation, always_specify_types
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      // ignore: avoid_print
      print('Logout error $e');
    }
  }
}
