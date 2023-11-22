import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/product_model.dart';
import 'package:flutter_todo_app/utils/utils.dart';

class ProductRepository {
  Future<bool> _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<ProductModel?> fetchData(BuildContext context) async {
    try {
      bool isConnected = await _checkInternetConnectivity();
      if (!isConnected) {
        if (!context.mounted) return null;
        return Utils.showSnackbar("No interenet connection", context);
      }

      final response = await Dio().get("https://dummyjson.com/products");
      if (response.statusCode == HttpStatus.ok) {
        return ProductModel.fromJson(response.data);
      }
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
    return null;
  }
}
