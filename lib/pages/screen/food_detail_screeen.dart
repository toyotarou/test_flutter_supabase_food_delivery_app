import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:readmore/readmore.dart';

import '../../Utils/consts.dart';
import '../../models/product_model.dart';
import '../../widgets/snack_bar.dart';

class FoodDetailScreeen extends ConsumerStatefulWidget {
  const FoodDetailScreeen({super.key, required this.product});

  final FoodModel product;

  @override
  ConsumerState<FoodDetailScreeen> createState() => _FoodDetailScreeenState();
}

class _FoodDetailScreeenState extends ConsumerState<FoodDetailScreeen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appbarParts(context),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            color: imageBackground,
            child: Image.asset(
              'assets/food-delivery/food_pattern.png',
              repeat: ImageRepeat.repeatY,
              color: imageBackground2,
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
          Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(height: 90),
                  Center(
                    child: Hero(
                      tag: widget.product.imageCard,
                      child: Image.network(widget.product.imageDetail, height: 320, fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      height: 45,
                      width: 120,
                      decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    quantity = quantity > 1 ? quantity - 1 : 1;
                                  }),
                              child: const Icon(Icons.remove, color: Colors.white),
                            ),
                            const SizedBox(width: 15),
                            Text(quantity.toString(), style: const TextStyle(color: Colors.white, fontSize: 18)),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap:
                                  () => setState(() {
                                    quantity++;
                                  }),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.product.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                          Text(
                            widget.product.specialItems,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            const TextSpan(text: r'$', style: TextStyle(color: red, fontSize: 14)),
                            TextSpan(
                              text: '${widget.product.price}',
                              style: const TextStyle(fontSize: 30, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      foodInfo('assets/food-delivery/icon/star.png', widget.product.rate.toString()),
                      foodInfo('assets/food-delivery/icon/fire.png', '${widget.product.rate} Kcal'),
                      foodInfo('assets/food-delivery/icon/time.png', '${widget.product.rate} Min'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ReadMoreText(
                    desc,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, height: 1.5, color: Colors.black),
                    trimLength: 110,
                    trimCollapsedText: 'Read More',
                    trimExpandedText: 'Read Less',
                    colorClickableText: red,
                    moreStyle: const TextStyle(fontWeight: FontWeight.bold, color: red),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Colors.transparent,
        label: MaterialButton(
          onPressed: () async {
            // await ref
            //     .read(cartProvider)
            //     .addCart(widget.product.name, widget.product.toMap(), quantity);
            //
            //
            //

            showSnackBar(context, '${widget.product.name} added to cart!', Colors.green);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          height: 65,
          color: red,
          minWidth: 350,
          child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.3)),
        ),
      ),
    );
  }

  Row foodInfo(String image, String value) {
    return Row(
      children: <Widget>[
        Image.asset(image, width: 25),
        const SizedBox(width: 10),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
      ],
    );
  }

  AppBar appbarParts(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 80,
      forceMaterialTransparency: true,
      actions: <Widget>[
        const SizedBox(width: 27),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          ),
        ),
        const Spacer(),
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: const Icon(Icons.more_horiz_rounded, color: Colors.black, size: 18),
        ),
        const SizedBox(width: 27),
      ],
    );
  }
}
