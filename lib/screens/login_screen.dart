import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/common/common_textfield.dart';
import 'package:flutter_todo_app/constants/validator.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:flutter_todo_app/provider/signup_provider.dart';
import 'package:flutter_todo_app/screens/bottom_nav_screen.dart';
import 'package:flutter_todo_app/screens/signup_screen.dart';
import 'package:flutter_todo_app/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  User? userId = FirebaseAuth.instance.currentUser;
  final fireStore = FirebaseFirestore.instance.collection("User Record");

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final signUpProvider = context.watch<SignupProvider>();
    final provider = Provider.of<ToDoProvider>(context);
    final sProvider = Provider.of<SignupProvider>(context, listen: false);

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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CommonTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "please enter login id";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "Please Enter a Valid E-mail Address";
                          }
                          return null;
                        }),
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: "Enter Email",
                        textInputAction: TextInputAction.next),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CommonTextFormField(
                      hintText: 'Enter your password',
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          Validator.validatePassword(passwordController.text),
                      isPassword: true,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: color.background,
                          border: Border.all(color: color.onBackground),
                          borderRadius: BorderRadius.circular(25)),
                      child: TextButton(
                          onPressed: () async {
                            context
                                .read<SignupProvider>()
                                .saveData(emailController.text);

                            if (_formkey.currentState!.validate()) {
                              sProvider.setLoading(true);

                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavScreen(),
                                    ),
                                    (route) => false);
                              }).catchError((e) {
                                if (e is FirebaseAuthException) {
                                  switch (e.code) {
                                    case 'INVALID_LOGIN_CREDENTIALS':
                                      Utils.showSnackbar(
                                          'Incorrect username or password',
                                          context);

                                      break;
                                    case 'VALID_LOGIN_CREDENTIALS':
                                      Utils.showSnackbar(
                                          "Login Sucessful", context);
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              }).whenComplete(() {
                                sProvider.setLoading(false);
                              });
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 20, color: color.onBackground),
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
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 18),
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
                            style: TextStyle(
                                fontSize: 20, color: color.onBackground),
                          )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 18),
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: color.onBackground),
                          borderRadius: BorderRadius.circular(25)),
                      child: TextButton.icon(
                          onPressed: () async {
                            User? user = await provider.signInWithGoogle();
                            if (!context.mounted) return;
                            context.read<ToDoProvider>().saveUserMail();
                            provider.setUserProfileData(
                              id: user?.email,
                              nam: user?.displayName,
                              mail: user?.email,
                              no: user?.phoneNumber,
                            );
                            if (user != null) {
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavScreen(),
                                  ),
                                  (route) => false);
                            } else {
                              if (!context.mounted) return;
                              return Utils.showSnackbar(
                                  "Something went wrong", context);
                            }
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                          ),
                          label: Text(
                            "SignUp with google",
                            style: TextStyle(
                                fontSize: 20, color: color.onBackground),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            if (signUpProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
