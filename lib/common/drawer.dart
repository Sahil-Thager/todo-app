import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/theme_provider.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:flutter_todo_app/screens/bottom_nav_screen.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<ToDoProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 280,
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
                        child: Text(
                          provider.profile?["profile"]["Name"][0] ?? "",
                          style:
                              TextStyle(color: color.background, fontSize: 20),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      provider.profile?["profile"]["Name"] ?? "",
                      style: TextStyle(
                        color: color.onBackground,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      provider.profile?["profile"]["Email"] ?? "",
                      style: TextStyle(
                        color: color.onBackground,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      provider.profile?["profile"]["Mobile"] ?? "",
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
                    return const BottomNavScreen();
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
              Icons.dark_mode,
              color: color.onBackground,
            ),
            title: Text(
              "Dark Theme",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color.onBackground),
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: ((value) {
                themeProvider.toggleTheme();
              }),
            ),
          ),
          ListTile(
            onTap: (() {
              logoutDialog(context);
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
        ],
      ),
    );
  }
}
