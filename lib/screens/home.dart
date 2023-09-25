import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo.dart';
import 'package:flutter_todo_app/notifications/notification_services.dart';
import 'package:flutter_todo_app/provider/list_provider.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My TODO APP",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 22),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.account_circle_rounded),
                      ),
                    ),
                    Text(
                      "User's Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
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
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: const Text(
                  "Home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                ),
                title: Text(
                  "User's account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: Text(
                  "Settings",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.black,
                ),
                title: const Text(
                  "LogOut",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        backgroundColor: tdBGColor,
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: context.read<ToDoProvider>().filter,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 10),
                      prefixIcon: Icon(
                        Icons.search,
                        color: tdBlack,
                        size: 20,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        maxHeight: 20,
                        minWidth: 25,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: tdGrey),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "All ToDos",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: tdBlack,
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
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: tdBGColor,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/sahil1.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showDialog(BuildContext context) async {
  context.read<ToDoProvider>().getData();
  return showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text(
              "User's Profile",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.amber,
                    image: const DecorationImage(
                      image: AssetImage('assets/sahil1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  context.watch<ToDoProvider>().name,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "G-Mail",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  context.watch<ToDoProvider>().email,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Mobile",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  context.watch<ToDoProvider>().number,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
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
            tileColor: Colors.white,
            leading: Icon(
              widget.todo.isDone
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: tdBlue,
            ),
            title: Text(
              widget.todo.todoText ?? 'null',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
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
