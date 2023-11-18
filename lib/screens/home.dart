import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/common/common_textfield.dart';
import 'package:flutter_todo_app/common/drawer.dart';
import 'package:flutter_todo_app/common/my_tile.dart';
import 'package:flutter_todo_app/constants/home_appbar.dart';
import 'package:flutter_todo_app/model/todo.dart';
import 'package:flutter_todo_app/notifications/notification_services.dart';
import 'package:flutter_todo_app/provider/theme_provider.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';
import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ToDo? todo;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ToDoProvider>().getData();
      if (!context.mounted) return;
      await context.read<ToDoProvider>().getUserMail();

      if (!context.mounted) return;
      await context.read<ToDoProvider>().getUserProfileData();

      if (!context.mounted) return;
      await context.read<ToDoProvider>().todosData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: color.background,
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CommonTextFormField(
                  onChanged: (text) {
                    context.read<ToDoProvider>().filter(text);
                  },
                  textInputAction: TextInputAction.done,
                  contentPadding: const EdgeInsets.only(bottom: 10),
                  prefixIcon: Icon(
                    Icons.search,
                    color: color.outline,
                    size: 20,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    maxHeight: 20,
                    minWidth: 25,
                  ),
                  hintText: 'Search',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "All ToDos",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: color.onBackground,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Consumer<ToDoProvider>(
                builder: (context, provider, child) {
                  return provider.filteredList.isEmpty
                      ? const Center(child: Text('Make Todo'))
                      : ListView.builder(
                          itemCount: provider.filteredList.length,
                          itemBuilder: (context, index) {
                            final element =
                                provider.filteredList.elementAt(index);

                            return MyTile(
                              provider: provider,
                              myDecoration:
                                  provider.docList[index].data()["isDone"]
                                      ? TextDecoration.lineThrough
                                      : null,
                              icon: provider.docList[index].data()["isDone"]
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              onIconButtonTap: () {
                                todoDelete(context, index).whenComplete(() {
                                  provider.todosData();
                                });
                              },
                              onTileTap: () {
                                provider.toggleItemSelection(
                                    provider.docList[index]);
                              },
                              todo: ToDo(
                                  id: element.id.toString(),
                                  todoText: element.data()["title"],
                                  isDone: false,
                                  triggerNotification10:
                                      element.data()["notificationTrigger10"],
                                  date: DateTime.parse(element.data()["time"])),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> logoutDialog(BuildContext context) async {
  final color = Theme.of(context).colorScheme;
  final theme = Provider.of<ThemeProvider>(context, listen: false);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Do You Want to Logout",
            style: TextStyle(color: color.onBackground, fontSize: 18),
          ),
        ),
        content: Row(
          children: [
            const SizedBox(
              width: 40,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                theme.logout();

                CustomSharedPrefrences.remove();
                final GoogleSignIn googleSignIn = GoogleSignIn();
                await FirebaseAuth.instance.signOut();
                await googleSignIn.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return const LogInScreen();
                  },
                ), (route) => false);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> todoDelete(BuildContext context, index) async {
  final color = Theme.of(context).colorScheme;
  final provider = Provider.of<ToDoProvider>(context, listen: false);
  NotificationServices notificationServices = NotificationServices();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Do You Want to Delete",
            style: TextStyle(color: color.onBackground, fontSize: 18),
          ),
        ),
        content: Row(
          children: [
            const SizedBox(
              width: 40,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                notificationServices.cancelNotification(index);

                provider
                    .deleteToDoItem(index, provider.docList[index].id)
                    .then((value) => Navigator.pop(context));
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      );
    },
  );
}
