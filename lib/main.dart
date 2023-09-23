import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/firebase_options.dart';
import 'package:flutter_todo_app/provider/list_provider.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider<ToDoProvider>(
      create: (context) => ToDoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: const LogInScreen(),
      // theme: ThemeData.dark(),
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
    );
  }
}
