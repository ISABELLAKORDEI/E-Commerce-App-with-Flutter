import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/widgets.dart';

import '../models/product_model.dart';

class WishlistScreen extends StatelessWidget {
  static const String routeName = '/wishlist';

  const WishlistScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const WishlistScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Wishlist'),
        bottomNavigationBar: const CustomNavBar(),
        body: GridView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16.0,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.2,
          ),
          itemCount: Product.products.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: ProductCard(
                product: Product.products[index],
                widthFactor: 1.1,
                leftPosition: 100,
                isWishlist: true,
              ),
            );
          },
        ));
  }
}
