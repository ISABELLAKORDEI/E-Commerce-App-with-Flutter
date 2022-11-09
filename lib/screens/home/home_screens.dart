import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/widgets.dart';

class Homescreen extends StatelessWidget {
  static const String routename = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => Homescreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Zero to Unicorn'),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
