import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/logger/logger_repository.dart';
import 'package:e_commerce_app/misc/get_os.dart';
import 'package:e_commerce_app/models/logger/log_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/models.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
  }

  void _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(const CartLoaded());
      await Logger.log(Log(
          typeOfLog: 'Info',
          microservice: 'Cart MNGT',
          message: 'Cart loaded',
          screen: 'Cart Screen',
          time: TimeOfDay.now().toString(),
          os: Misc.getOS()));
    } catch (e) {
      emit(CartError());
      await Logger.log(Log(
          typeOfLog: 'Fatal',
          microservice: 'Cart MNGT',
          message: 'Error Loading Cart ${e.toString()}',
          screen: 'Cart Screen',
          time: TimeOfDay.now().toString(),
          os: Misc.getOS()));
    }
  }

  void _onAddProduct(
    AddProduct event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      try {
        emit(
          CartLoaded(
            cart: Cart(
              products: List.from((state as CartLoaded).cart.products)
                ..add(event.product),
            ),
          ),
        );
        await Logger.log(Log(
            typeOfLog: 'Debug',
            microservice: 'Cart MNGT',
            message: 'Product added',
            screen: 'Cart Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      } on Exception catch (e) {
        emit(CartError());
        await Logger.log(Log(
            typeOfLog: 'Error',
            microservice: 'Cart MNGT',
            message: 'Error adding product ${e.toString()}',
            screen: 'Cart Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      }
    }
  }

  void _onRemoveProduct(
    RemoveProduct event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      try {
        emit(
          CartLoaded(
            cart: Cart(
              products: List.from((state as CartLoaded).cart.products)
                ..remove(event.product),
            ),
          ),
        );
        await Logger.log(Log(
            typeOfLog: 'Debug',
            microservice: 'Cart MNGT',
            message: 'Product removed',
            screen: 'Cart Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      } on Exception catch (e) {
        emit(CartError());
        await Logger.log(Log(
            typeOfLog: 'Error',
            microservice: 'Cart MNGT',
            message: 'Error removing product ${e.toString()}',
            screen: 'Cart Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      }
    }
  }
}
