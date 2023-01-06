import 'dart:convert';
import 'dart:io';

import 'package:e_commerce_app/logger/rest_api.dart';
import 'package:e_commerce_app/models/logger/log_model.dart';

NetworkUtil _networkUtil = NetworkUtil();

class Logger {
  static Future<void> log(Log log) async {
    const createLogUrl = '/api';

    try {
      await _networkUtil.postReq(
        createLogUrl,
        body: json.encode(log.toJson()),
      );
    } on SocketException {
      throw ('Check network connection!');
    } catch (e) {
      rethrow;
    }
  }
}
