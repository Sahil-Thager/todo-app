import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Products"),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.productList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemCount: provider.productList.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  height: 300,
                  width: 120,
                  child: Column(
                    children: [
                      Image.network(
                          provider.productList[index].thumbnail.toString()),
                      Text(provider.productList[index].description.toString()),
                      Text(provider.productList[index].price.toString()),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
