import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/blocs/blocs.dart';
import 'package:e_commerce_app/logger/logger_repository.dart';
import 'package:e_commerce_app/models/logger/log_model.dart';
import 'package:e_commerce_app/models/models.dart';
import 'package:e_commerce_app/repositories/checkout/checkout_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _checkoutRepository;
  StreamSubscription? _cartSubscription;
  StreamSubscription? _checkoutSubscription;

  CheckoutBloc({
    required CartBloc cartBloc,
    required CheckoutRepository checkoutRepository,
  })  : _checkoutRepository = checkoutRepository,
        super(
          cartBloc.state is CartLoaded
              ? CheckoutLoaded(
                  products: (cartBloc.state as CartLoaded).cart.products,
                  deliveryFee:
                      (cartBloc.state as CartLoaded).cart.deliveryFeeString,
                  subtotal: (cartBloc.state as CartLoaded).cart.subtotalString,
                  total: (cartBloc.state as CartLoaded).cart.totalString,
                )
              : CheckoutLoading(),
        ) {
    on<UpdateCheckout>(_onUpdateCheckout);
    on<ConfirmCheckout>(_onConfirmCheckout);

    _cartSubscription = cartBloc.stream.listen((state) {
      if (state is CartLoaded) {
        add(
          UpdateCheckout(cart: state.cart),
        );
      }
    });
  }

  void _onUpdateCheckout(
    UpdateCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is CheckoutLoaded) {
      final state = this.state as CheckoutLoaded;
      emit(
        CheckoutLoaded(
          email: event.email ?? state.email,
          fullName: event.fullName ?? state.fullName,
          products: event.cart?.products ?? state.products,
          deliveryFee: event.cart?.deliveryFeeString ?? state.deliveryFee,
          subtotal: event.cart?.subtotalString ?? state.subtotal,
          total: event.cart?.totalString ?? state.total,
          address: event.address ?? state.address,
          city: event.city ?? state.city,
          country: event.country ?? state.country,
          zipCode: event.zipCode ?? state.zipCode,
        ),
      );
      await Logger.log(Log(
          typeOfLog: 'INFO',
          microservice: 'Checkout SYS',
          message: 'Checkout loaded',
          screen: 'Checkout Screen',
          time: TimeOfDay.now().toString(),
          os: Platform.operatingSystem));
    }
  }

  void _onConfirmCheckout(
    ConfirmCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    _checkoutSubscription?.cancel();
    if (state is CheckoutLoaded) {
      try {
        await _checkoutRepository.addCheckout(event.checkout);
        emit(CheckoutLoading());
        await Logger.log(Log(
            typeOfLog: 'DEBUG',
            microservice: 'Checkout SYS',
            message: 'Checkout confirmed',
            screen: 'Checkout Screen',
            time: TimeOfDay.now().toString(),
            os: Platform.operatingSystem));
      } catch (e) {
        await Logger.log(Log(
            typeOfLog: 'ERROR',
            microservice: 'Checkout SYS',
            message: 'Error confirming checkout ${e.toString()}',
            screen: 'Checkout Screen',
            time: TimeOfDay.now().toString(),
            os: Platform.operatingSystem));
      }
    }
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
