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

      default:
        return errorRoute();
    }
  }
  static Route _errorRoute() {
    retu
  }
  
}
