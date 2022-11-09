import 'package:e_commerce_app/config/app_router.dart';
import 'package:e_commerce_app/screens/home/home_screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zero to Unicorn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: Homescreen,
      routeName,
      home: Homescreen(),
    );
  }
}
