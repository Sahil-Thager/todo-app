import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/product_model.dart';
import 'package:flutter_todo_app/repository/product_repositroy.dart';

class ProductProvider extends ChangeNotifier {
  ProductRepository repository = ProductRepository();
  List<Products> productList = [];

  Future<void> getData(BuildContext context) async {
    final response = await repository.fetchData(context);
    productList = response?.products ?? [];
    notifyListeners();
  }
}
