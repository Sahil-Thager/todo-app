import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/photos_provider.dart';
import 'package:provider/provider.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PhotosProvider>().fetchPhotos(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Photos"),
      ),
      body: Consumer<PhotosProvider>(
        builder: (context, provider, child) {
          if (provider.photos.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: provider.photos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text(provider.photos[index].title.toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
