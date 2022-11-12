import 'package:e_commerce_app/blocs/wishlist/wishlist_bloc.dart';
import 'package:e_commerce_app/config/app_router.dart';
import 'package:e_commerce_app/config/theme.dart';
import 'package:e_commerce_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/cart/cart_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WishlistBloc()..add(WishlistStarted())),
        BlocProvider(create: (_) => CartBloc()..add(LoadCart())),
      ],
      child: MaterialApp(
        title: 'Zero to Unicorn',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
