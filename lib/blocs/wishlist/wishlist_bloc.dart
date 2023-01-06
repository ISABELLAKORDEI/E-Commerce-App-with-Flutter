import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/logger/logger_repository.dart';
import 'package:e_commerce_app/misc/get_os.dart';
import 'package:e_commerce_app/models/logger/log_model.dart';
import 'package:e_commerce_app/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistLoading()) {
    on<StartWishlist>(_onStartWishlist);
    on<AddProductToWishlist>(_onAddProductToWishlist);
    on<RemoveProductFromWishlist>(_onRemoveProductFromWishlist);
  }

  void _onStartWishlist(
    StartWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(const WishlistLoaded());
      await Logger.log(Log(
          typeOfLog: 'Debug',
          microservice: 'Wishlist MGNT',
          message: 'User Wishlist loaded',
          screen: 'Wishlist Screen',
          time: TimeOfDay.now().toString(),
          os: Misc.getOS()));
    } catch (e) {
      emit(WishlistError());
      await Logger.log(Log(
          typeOfLog: 'Fatal',
          microservice: 'Wishlist MGNT',
          message: 'Error loading user Wishlist',
          screen: 'Wishlist Screen',
          time: TimeOfDay.now().toString(),
          os: Misc.getOS()));
    }
  }

  void _onAddProductToWishlist(
    AddProductToWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    if (state is WishlistLoaded) {
      try {
        emit(
          WishlistLoaded(
            wishlist: Wishlist(
              products: List.from((state as WishlistLoaded).wishlist.products)
                ..add(event.product),
            ),
          ),
        );
        await Logger.log(Log(
            typeOfLog: 'Info',
            microservice: 'Wishlist MGNT',
            message: 'Product added to wishlist',
            screen: 'Wishlist Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      } on Exception catch (e) {
        emit(WishlistError());
        await Logger.log(Log(
            typeOfLog: 'Fatal',
            microservice: 'Wishlist MGNT',
            message: 'Error adding product to wishlist: ${e.toString()}',
            screen: 'Wishlist Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      }
    }
  }

  void _onRemoveProductFromWishlist(
    RemoveProductFromWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    if (state is WishlistLoaded) {
      try {
        emit(
          WishlistLoaded(
            wishlist: Wishlist(
              products: List.from((state as WishlistLoaded).wishlist.products)
                ..remove(event.product),
            ),
          ),
        );
        await Logger.log(Log(
            typeOfLog: 'Info',
            microservice: 'Wishlist MGNT',
            message: 'Product removed from wishlist',
            screen: 'Wishlist Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      } on Exception catch (e) {
        emit(WishlistError());
        await Logger.log(Log(
            typeOfLog: 'Fatal',
            microservice: 'Wishlist MGNT',
            message: 'Error removing product from wishlist: ${e.toString()}',
            screen: 'Wishlist Screen',
            time: TimeOfDay.now().toString(),
            os: Misc.getOS()));
      }
    }
  }
}
