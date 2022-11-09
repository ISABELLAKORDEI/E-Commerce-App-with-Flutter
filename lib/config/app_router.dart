import 'package:e_commerce_app/screens/cart/cart_screen.dart';
import 'package:e_commerce_app/screens/home/screens.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('This is route:${settings.name}');

    switch (settings.name) {
      case '/':
        return HomeScreen.route();
      case Homescreen.routeName:
        return Homescreen.route();

      case CartScreen.routename:
        return CartScreen.route();
    

      default:
        return errorRoute();
    }
  }
  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: RouteSettings(name: '/error'), 
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text('Error')),
       ),
  }
}
