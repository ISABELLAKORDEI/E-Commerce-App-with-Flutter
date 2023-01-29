import 'dart:async';

import 'package:e_commerce_app/blocs/blocs.dart';
import 'package:e_commerce_app/config/app_router.dart';
import 'package:e_commerce_app/config/theme.dart';
import 'package:e_commerce_app/repositories/category/category_repository.dart';
import 'package:e_commerce_app/repositories/checkout/checkout_repository.dart';
import 'package:e_commerce_app/repositories/product/product_repository.dart';
import 'package:e_commerce_app/screens/auth/auth_controller.dart';
import 'package:e_commerce_app/screens/auth/login.dart';
import 'package:e_commerce_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await runZonedGuarded(
    () async => runApp(const MyApp()),
    (_, __) {},
  );

  runApp(const MyApp());
  debugPrint('Hello there...');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool authCheck = false;
  final auth = Auth();
  Future<bool> startApp() async {
    var loggedIn = await auth.getStorageToken();
    bool foundToken = false;
    if (loggedIn) {
      auth.doGetProfile();
      authCheck = true;
      foundToken = true;
    }
    return foundToken;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WishlistBloc()..add(StartWishlist())),
        BlocProvider(create: (_) => CartBloc()..add(LoadCart())),
        BlocProvider(
          create: (context) => CheckoutBloc(
            cartBloc: context.read<CartBloc>(),
            checkoutRepository: CheckoutRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => CategoryBloc(
            categoryRepository: CategoryRepository(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(LoadProducts()),
        ),
      ],
      child: GetMaterialApp(
        title: 'Zero to Unicorn',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        // initialRoute: SplashScreen.routeName,
        home: FutureBuilder(
          future: startApp(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Scaffold(
                  body: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  debugPrint('$snapshot.error');
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (authCheck) {
                    debugPrint("... logged in");
                    return const SplashScreen();
                  } else {
                    debugPrint("not logged in ");
                    return const Login();
                  }
                }
            }
          },
        ),
      ),
    );
  }
}
