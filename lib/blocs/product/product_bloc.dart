import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/logger/logger_repository.dart';
import 'package:e_commerce_app/misc/get_os.dart';
import 'package:e_commerce_app/models/logger/log_model.dart';
import 'package:e_commerce_app/models/models.dart';
import 'package:e_commerce_app/repositories/product/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
  }

  void _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateProducts(products),
          ),
        );
    await Logger.log(Log(
        typeOfLog: 'Debug',
        microservice: 'Products SYS',
        message: 'Subscribing to products',
        screen: 'Products Screen',
        time: TimeOfDay.now().toString(),
        os: Misc.getOS()));
  }

  void _onUpdateProducts(
    UpdateProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoaded(products: event.products));
    await Logger.log(Log(
        typeOfLog: 'Info',
        microservice: 'Products SYS',
        message: 'Products updated',
        screen: 'Products Screen',
        time: TimeOfDay.now().toString(),
        os: Misc.getOS()));
  }
}
