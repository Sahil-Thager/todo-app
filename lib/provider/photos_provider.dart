import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/photos_model.dart';
import 'package:flutter_todo_app/utils/utils.dart';

class PhotosProvider extends ChangeNotifier {
  List<PhotosModel> _photos = [];

  List<PhotosModel> get photos => _photos;
  Future<bool> _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<PhotosModel?> fetchPhotos(BuildContext context) async {
    try {
      bool isConnected = await _checkInternetConnectivity();
      if (!isConnected) {
        if (!context.mounted) return null;
        return Utils.showSnackbar("No interenet connection", context);
      }

      final response =
          await Dio().get('https://jsonplaceholder.typicode.com/photos');

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        _photos = jsonList.map((json) => PhotosModel.fromJson(json)).toList();
        notifyListeners();
      } else {
        if (!context.mounted) return null;
        Utils.showSnackbar("SomeThing Went Wrong", context);
      }
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
    return null;
  }
}
