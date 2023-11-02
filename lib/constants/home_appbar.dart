import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final provider = Provider.of<ToDoProvider>(context);
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CircleAvatar(
                child: Text(provider.profile?["profile"]["Name"][0] ??
                    provider.user?.displayName?[0] ??
                    "null"),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final color = Theme.of(context).colorScheme;
    final provider = Provider.of<ToDoProvider>(context, listen: false);

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
                    provider.profile?["profile"]["Name"][0] ??
                        provider.user?.displayName?[0] ??
                        "null",
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
                  provider.profile?["profile"]["Name"] ??
                      provider.user?.displayName ??
                      "null",
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
                  provider.profile?["profile"]["Email"] ??
                      provider.user?.email ??
                      "null",
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
                  provider.profile?["profile"]["Mobile"] ??
                      provider.user?.phoneNumber ??
                      "null",
                  style: TextStyle(
                    fontSize: 15,
                    color: color.onBackground,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
