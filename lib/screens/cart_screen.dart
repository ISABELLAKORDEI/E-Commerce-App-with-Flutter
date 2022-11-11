import 'package:e_commerce_app/screens/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  static const String routename = 'cart';

  const CartScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routename),
        builder: (_) => const Homescreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Cart'),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
