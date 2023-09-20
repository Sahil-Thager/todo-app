import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo.dart';
import 'package:flutter_todo_app/notifications/notification_services.dart';
import 'package:flutter_todo_app/provider/list_provider.dart';
import 'package:flutter_todo_app/screens/add_screen.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tdBGColor,
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onChanged: context.read<ToDoProvider>().filter,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
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
                            itemBuilder: (context, myindex) {
                              ToDo todo =
                                  provider.filteredTodoList.elementAt(myindex);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyTile(
                                  todo: todo,
                                  index: myindex,
                                ),
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
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/sahil1.jpg'),
          ),
        ),
      ]),
    );
  }
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
  int selectedIndex = 0;

  @override
  void initState() {
    notificationServices.intialiseNotification();

    super.initState();
    notificationServices.sendNotification("gfghfg ", "only 10 minutes left");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoProvider>(
      builder: ((context, provider, child) {
        return ListTile(
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
          subtitle: TimeCounter(todo: widget.todo),
        );
      }),
    );
  }
}

class TimeCounter extends StatefulWidget {
  const TimeCounter({
    super.key,
    required this.todo,
  });

  final ToDo todo;

  @override
  State<TimeCounter> createState() => _TimeCounterState();
}

Stream<DateTime> dateTimeStream(ToDo todo, VoidCallback callback) async* {
  var current = DateTime.now();

  while (current.isBefore(todo.date)) {
    final timeDifference = todo.date.difference(current);

    if (timeDifference.inSeconds <= 600 && !todo.triggerNotification) {
      todo.triggerNotification = true;

      callback.call();
    }

    yield current;
    await Future.delayed(const Duration(seconds: 1));
    current = current.add(const Duration(seconds: 1));
  }
}

class _TimeCounterState extends State<TimeCounter> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.todo.date.toString());
  }
}
