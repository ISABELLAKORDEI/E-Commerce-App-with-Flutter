import 'package:e_commerce_app/blocs/blocs.dart';
import 'package:e_commerce_app/widgets/product_card.dart';
import 'package:e_commerce_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  static const String routeName = '/wishlist';

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
        bottomNavigationBar: const CustomNavBar(screen: routeName),
        body: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const CircularProgressIndicator();
            }
            if (state is WishlistLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2.25,
                  ),
                  itemCount: state.wishlist.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: ProductCard(
                      product: state.wishlist.products[index],
                      widthFactor: 1.1,
                      additionalButtons: true,
                    ));
                  },
                ),
              );
            }
            return const Text('');
          },
        ));
  }
}
