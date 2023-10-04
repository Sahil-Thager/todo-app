import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/signup_provider.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:flutter_todo_app/screens/signup_screen.dart';
import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';
import 'package:flutter_todo_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final signUpProvider = context.watch<SignupProvider>();

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        backgroundColor: color.background,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Login",
          style: TextStyle(
            color: color.onBackground,
            fontSize: 30,
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: signUpProvider.emailController,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "please enter login id";
                  }
                  if (!EmailValidator.validate(value)) {
                    return "Please Enter a Valid E-mail Address";
                  }
                  return null;
                }),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 5),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: "Enter Login id",
                    hintStyle: TextStyle(color: color.outline)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: passwordController,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "please enter Password";
                  }
                  return null;
                }),
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 5),
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    hintText: "Enter Password",
                    hintStyle: TextStyle(color: color.outline)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: color.background,
                    border: Border.all(color: color.onBackground),
                    borderRadius: BorderRadius.circular(25)),
                child: TextButton(
                    onPressed: () {
                      context.read<SignupProvider>().saveData();
                      if (_formkey.currentState!.validate()) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: signUpProvider.emailController.text,
                                password: passwordController.text)
                            .then((value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs
                              .setString(
                                  Keys.email.name, value.user?.email ?? '')
                              .then((value) =>
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const Home();
                                    },
                                  )));
                        }).catchError((e) {
                          if (e is FirebaseAuthException) {
                            switch (e.code) {
                              case 'INVALID_LOGIN_CREDENTIALS':
                                Utils.showSnackbar(
                                  'Incorrect username or password',
                                  context,
                                );
                                break;
                              default:
                                break;
                            }
                          }
                        });
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: color.onBackground),
                    )),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "or",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "Do not have any account please Signup",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 18),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: color.onBackground),
                    borderRadius: BorderRadius.circular(25)),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignupScreen();
                      }));
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(fontSize: 20, color: color.onBackground),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
