import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/widgets.dart';

import '../models/category.dart';

class Homescreen extends StatelessWidget {
  static const String routeName = '/';

  const Homescreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const Homescreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Zero to Unicorn'),
      body: Column(children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 1.5,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: Category.categories
              .map((category) => HeroCarouselCard(category: category))
              .toList(),
        ),
        const SectionTitle(title: 'RECOMMENDED'),
        ProductCarousel(
            products: Product.products
                .where((product) => product.isRecommended)
                .toList()),
        const SectionTitle(title: 'MOST POPULAR'),
        ProductCarousel(
            products:
                Product.products.where((product) => product.isPopular).toList())
      ]),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
