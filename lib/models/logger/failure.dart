// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.g.dart';
part 'failure.freezed.dart';

@freezed
class ECommerceAppValidationError with _$ECommerceAppValidationError {
  factory ECommerceAppValidationError(
    int code,
    List<ECommerceAppFieldValidationError> errors,
  ) = _ECommerceAppValidationError;

  factory ECommerceAppValidationError.fromJson(Map<String, dynamic> json) =>
      _$ECommerceAppValidationErrorFromJson(json);
}

@freezed
class ECommerceAppFieldValidationError with _$ECommerceAppFieldValidationError {
  factory ECommerceAppFieldValidationError(
    String key,
    List<String> errors,
  ) = _ECommerceAppFieldValidationError;

  factory ECommerceAppFieldValidationError.fromJson(
          Map<String, dynamic> json) =>
      _$ECommerceAppFieldValidationErrorFromJson(json);
}

class Failure implements Exception {
  Failure({
    required this.message,
    this.errors = const [],
  });

  final String message;
  List<ECommerceAppFieldValidationError> errors;

  @override
  String toString() {
    return message + errors.toString();
  }

  List<String> errorMessages() {
    final _errors = <String>[];

    for (final error in errors) {
      _errors.add(
        error.errors[0],
      );
    }

    return List.castFrom<dynamic, String>(_errors);
  }
}
