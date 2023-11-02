import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/theme_provider.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
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
        ],
      ),
    );
  }
}
