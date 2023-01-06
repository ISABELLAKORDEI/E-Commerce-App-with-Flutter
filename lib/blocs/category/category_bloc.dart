import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/logger/logger_repository.dart';
import 'package:e_commerce_app/models/logger/log_model.dart';
import 'package:e_commerce_app/models/models.dart';
import 'package:e_commerce_app/repositories/category/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  StreamSubscription? _categorySubscription;

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<UpdateCategories>(_onUpdateCategories);
  }

  void _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    _categorySubscription?.cancel();
    _categorySubscription = _categoryRepository.getAllCategories().listen(
          (products) => add(
            UpdateCategories(products),
          ),
        );
    await Logger.log(Log(
        typeOfLog: 'DEBUG',
        microservice: 'Categories MNGT',
        message: 'All categories loaded',
        screen: 'Products Screen',
        time: TimeOfDay.now().toString(),
        os: Platform.operatingSystem));
  }

  void _onUpdateCategories(
    UpdateCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      CategoryLoaded(categories: event.categories),
    );
    await Logger.log(Log(
        typeOfLog: 'DEBUG',
        microservice: 'Categories MNGT',
        message: 'All categories updated',
        screen: 'Products Screen',
        time: TimeOfDay.now().toString(),
        os: Platform.operatingSystem));
  }
}
