import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/widgets.dart';

class Homescreen extends StatelessWidget {
  static const String routename = '/';

  const Homescreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routename), builder: (_) => const Homescreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Zero to Unicorn'),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
