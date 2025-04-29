import 'package:flutter/material.dart';

import '../../Utils/consts.dart';
import '../../service/auth_service.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final AuthService authService = AuthService();

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // body: SafeArea(
      //   child: Column(
      //     children: <Widget>[
      //       ElevatedButton(
      //         onPressed: () {
      //           authService.logout(context);
      //         },
      //         child: const Icon(Icons.exit_to_app),
      //       ),
      //     ],
      //   ),
      // ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground,

            child: Image.asset("assets/food-delivery/food_pattern.png"),
          ),
        ],
      ),
    );
  }
}
