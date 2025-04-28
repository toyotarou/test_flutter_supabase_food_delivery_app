import 'package:flutter/material.dart';

import '../../service/auth_service.dart';
import '../../widgets/my_button.dart';
import '../../widgets/snack_bar.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailEditingController = TextEditingController();

  TextEditingController passwordEditingController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  bool isPasswordHidden = true;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Image.asset('assets/6343825.jpg', width: double.maxFinite, height: 500, fit: BoxFit.cover),

            TextField(
              controller: emailEditingController,
              decoration: const InputDecoration(labelText: 'email', border: OutlineInputBorder()),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: passwordEditingController,
              decoration: InputDecoration(
                labelText: 'password',
                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => isPasswordHidden = !isPasswordHidden);
                  },
                  icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                ),
              ),

              obscureText: isPasswordHidden,
            ),

            const SizedBox(height: 20),

            if (isLoading) const Center(child: CircularProgressIndicator()) else SizedBox(width: double.maxFinite, child: MyButton(onTap: _signUp, buttontext: 'Signup')),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text('have an account ?', style: TextStyle(fontSize: 18)),

                GestureDetector(
                  onTap: () {
                    // ignore: inference_failure_on_instance_creation, always_specify_types
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));
                  },

                  child: const Text(
                    'Login Here',

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue, letterSpacing: -1),
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
  Future<void> _signUp() async {
    final String email = emailEditingController.text.trim();
    final String password = passwordEditingController.text.trim();

    setState(() => isLoading = true);

    final String? result = await authService.signup(email, password);

    if (result == null) {
      // success case
      setState(() => isLoading = false);

      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Signup Successful! Now Turn to Login', Colors.green);

      // ignore: inference_failure_on_instance_creation, use_build_context_synchronously, always_specify_types
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      setState(() => isLoading = false);

      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Signup Failed:$result', Colors.red);
    }
  }
}
