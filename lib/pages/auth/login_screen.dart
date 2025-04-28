import 'package:flutter/material.dart';

import '../../widgets/my_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailEditingController = TextEditingController();

  TextEditingController passwordEditingController = TextEditingController();

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Image.asset('assets/login.jpg', width: double.maxFinite, height: 500, fit: BoxFit.cover),

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

                suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.visibility)),
              ),
            ),

            const SizedBox(height: 20),

            MyButton(onTap: () {}, buttontext: 'Login'),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text("Don't have an account ?", style: TextStyle(fontSize: 18)),

                GestureDetector(
                  onTap: () {
                    // ignore: inference_failure_on_instance_creation, always_specify_types
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const SignupScreen()));
                  },
                  child: const Text(
                    'Sign Up Here',

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
}
