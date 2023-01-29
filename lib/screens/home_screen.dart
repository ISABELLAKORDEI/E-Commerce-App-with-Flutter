import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/blocs/category/category_bloc.dart';
import 'package:e_commerce_app/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: const CustomAppBar(title: 'Louzies'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CategoryLoaded) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.5,
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: state.categories
                        .map((category) => HeroCarouselCard(
                              category: category,
                            ))
                        .toList(),
                  );
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
            const SectionTitle(title: 'RECOMMENDED'),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoaded) {
                  return ProductCarousel(
                      products: state.products
                          .where((product) => product.isRecommended)
                          .toList());
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
            const SectionTitle(title: 'MOST POPULAR'),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoaded) {
                  return ProductCarousel(
                      products: state.products
                          .where((product) => product.isPopular)
                          .toList());
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
    );
  }
}
