import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo.dart';
import 'package:flutter_todo_app/notifications/notification_services.dart';
import 'package:flutter_todo_app/provider/list_provider.dart';
import 'package:flutter_todo_app/provider/theme_provider.dart';
import 'package:flutter_todo_app/screens/add_screen.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';
import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ToDoProvider>().getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 190,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: color.background,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My TODO APP",
                        style: TextStyle(
                          fontSize: 30,
                          color: color.onBackground,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: CircleAvatar(
                          backgroundColor: color.onBackground,
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: color.background,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "User's Name",
                          style: TextStyle(
                            color: color.onBackground,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: (() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Home();
                      },
                    ),
                    (route) => false,
                  );
                }),
                leading: Icon(
                  Icons.home,
                  color: color.onBackground,
                ),
                title: const Text(
                  "Home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: color.onBackground,
                ),
                title: Text(
                  "User's account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color.onBackground),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: color.onBackground,
                ),
                title: Text(
                  "Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color.onBackground),
                ),
              ),
              ListTile(
                onTap: (() {
                  SharedPrefrencess.remove();
                  _auth.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const LogInScreen();
                    },
                  ), (route) => false);
                }),
                leading: Icon(
                  Icons.logout_rounded,
                  color: color.onBackground,
                ),
                title: Text(
                  "LogOut",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color.onBackground),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color: color.onBackground,
                ),
                title: Text(
                  "Dark Theme",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color.onBackground),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: ((value) {
                    themeProvider.setTheme();
                  }),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: color.background,
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.onSecondary,
                ),
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: context.read<ToDoProvider>().filter,
                    decoration: InputDecoration(
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
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: color.onBackground),
                    ),
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
                    return provider.filteredTodoList.isEmpty
                        ? const Center(child: Text('Make Todo'))
                        : ListView.builder(
                            itemCount: provider.filteredTodoList.length,
                            itemBuilder: (context, index) {
                              ToDo todo =
                                  provider.filteredTodoList.elementAt(index);
                              return MyTile(
                                todo: todo,
                                index: index,
                              );
                            },
                          );
                  },
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => const NewList()));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.add),
              )
            ],
          ),
        ));
  }

  AppBar _buildAppBar() {
    final color = Theme.of(context).colorScheme;

    return AppBar(
      iconTheme: IconThemeData(color: color.onBackground),
      backgroundColor: color.background,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 240),
        child: SizedBox(
          height: 40,
          width: 40,
          child: InkWell(
            onTap: () {
              _showDialog(context);
            },
            child: Consumer(
              builder: (context, value, child) {
                final email = context.watch<ToDoProvider>().email;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    child: Text(email.isNotEmpty ? email[0] : "O"),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showDialog(BuildContext context) async {
  final color = Theme.of(context).colorScheme;
  context.read<ToDoProvider>().getData();
  return showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              "User's Profile",
              style: TextStyle(fontSize: 20, color: color.onBackground),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: color.background,
                  radius: 50,
                  child: Text(
                    context.watch<ToDoProvider>().email[0],
                    style: TextStyle(
                      color: color.onBackground,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 12,
                      color: color.onBackground,
                    ),
                  ),
                ),
                Text(
                  context.watch<ToDoProvider>().name,
                  style: TextStyle(
                    fontSize: 15,
                    color: color.onBackground,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "G-Mail",
                    style: TextStyle(
                      fontSize: 12,
                      color: color.onBackground,
                    ),
                  ),
                ),
                Text(
                  context.watch<ToDoProvider>().email,
                  style: TextStyle(
                    fontSize: 15,
                    color: color.onBackground,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Mobile",
                    style: TextStyle(
                      fontSize: 12,
                      color: color.onBackground,
                    ),
                  ),
                ),
                Text(
                  context.watch<ToDoProvider>().number,
                  style: TextStyle(
                    fontSize: 15,
                    color: color.onBackground,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

class MyTile extends StatefulWidget {
  const MyTile({
    super.key,
    required this.todo,
    required this.index,
  });

  final ToDo todo;
  final int index;

  @override
  State<MyTile> createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    notificationServices.intialiseNotification();
    super.initState();

    forTenMinutNotification(() {
      final time = widget.todo.date.difference(DateTime.now());
      notificationServices.sendNotification(
          widget.todo.todoText.toString(), time.toString());
    });
    forOneDayNotification(() {
      final timer = widget.todo.date.difference(DateTime.now());
      notificationServices.sendNotification(
          widget.todo.todoText.toString(), timer.toString());
    });
  }

  void forTenMinutNotification(VoidCallback callback) {
    final todo = widget.todo;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeDifference = widget.todo.date.difference(DateTime.now());

      if (timeDifference.inSeconds <= 600 && !todo.triggerNotification) {
        callback.call();
        timer.cancel();
        todo.triggerNotification = true;
      }
    });
  }

  void forOneDayNotification(VoidCallback callback) {
    final todo = widget.todo;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeDifference = widget.todo.date.difference(DateTime.now());
      if (timeDifference.inSeconds <= 86400 && !todo.triggerNotification) {
        callback.call();
        timer.cancel();
        todo.triggerNotification = true;
        todo.triggerNotification = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    final color = Theme.of(context).colorScheme;
    return Consumer<ToDoProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              selectedIndex = widget.index;
              if (selectedIndex == widget.index) {
                provider.toggleItemSelection(widget.index);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: color.onInverseSurface,
            leading: Icon(
              widget.todo.isDone
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: color.onBackground,
            ),
            title: Text(
              widget.todo.todoText ?? 'null',
              style: TextStyle(
                fontSize: 16,
                color: color.onBackground,
                decoration:
                    widget.todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: tdRed,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  selectedIndex = widget.index;
                  if (selectedIndex == widget.index) {
                    provider.deleteToDoItem(widget.index);
                  }
                },
              ),
            ),
            subtitle: Text(widget.todo.date.toString()),
          ),
        );
      },
    );
  }
}
