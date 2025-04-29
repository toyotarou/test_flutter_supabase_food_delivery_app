import 'package:flutter/material.dart';

import '../../Utils/consts.dart';
import '../../models/on_bording_model.dart';
import 'app_main_screen.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  // final AuthService authService = AuthService();
  //

  final PageController _pageController = PageController();

  int currentPage = 0;

  ///
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground,

            child: Image.asset(
              'assets/food-delivery/food_pattern.png',

              color: imageBackground2,
              repeat: ImageRepeat.repeatY,
            ),
          ),

          Positioned(top: -80, right: 0, left: 0, child: Image.asset('assets/food-delivery/chef.png')),

          Positioned(top: 139, right: 50, child: Image.asset('assets/food-delivery/leaf.png', width: 80)),
          Positioned(top: 390, right: 40, child: Image.asset('assets/food-delivery/chili.png', width: 80)),

          Positioned(top: 230, left: -20, child: Image.asset('assets/food-delivery/ginger.png', width: 90, height: 90)),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustomClip(),

              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 75),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: data.length,

                        onPageChanged: (int index) {
                          setState(() {
                            currentPage = index;
                          });
                        },

                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(text: data[index]['title1'], style: const TextStyle(color: Colors.black)),
                                    TextSpan(text: data[index]['title2'], style: const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                              Text(
                                data[index]['description']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      // ignore: always_specify_types
                      children: List.generate(
                        data.length,
                        (int index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: currentPage == index ? 20 : 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: currentPage == index ? Colors.orange : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    MaterialButton(
                      onPressed: () {
                        // ignore: inference_failure_on_instance_creation, always_specify_types
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AppMainScreen()));
                      },
                      color: red,
                      height: 65,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: const Text('Get Started', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, 30);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 30);
    path.quadraticBezierTo(size.width / 2, -30, 0, 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
