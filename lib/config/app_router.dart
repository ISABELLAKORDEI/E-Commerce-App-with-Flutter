import 'package:e_commerce_app/models/models.dart';
import 'package:e_commerce_app/screens/screens.dart';
import 'package:e_commerce_app/screens/splash_screen.dart';
import 'package:e_commerce_app/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint('This is route:${settings.name}');

    switch (settings.name) {
      case Homescreen.routeName:
        return Homescreen.route();

      case CartScreen.routeName:
        return CartScreen.route();

      case CatalogScreen.routeName:
        return CatalogScreen.route(category: settings.arguments as Category);

      case ProductScreen.routeName:
        return ProductScreen.route(product: settings.arguments as Product);

      case SplashScreen.routeName:
        return SplashScreen.route();

      case WishlistScreen.routeName:
        return WishlistScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
            ));
  }
}
