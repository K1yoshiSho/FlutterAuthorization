// ignore_for_file: prefer_const_constructors, unnecessary_new, deprecated_member_use, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanaly/pages/register.dart';
import 'package:sanaly/pages/reset_pass.dart';
import 'package:sanaly/services/firebase_serv.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  bool isMailFiledFocus = false;
  bool isPassFiledFocus = false;
  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final Focus emailField;
    Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.green,
      ),
      child: emailField = Focus(
        child: TextFormField(
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: false,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Пожалуйста, введите ваш e-mail");
            }
            // reg expression for email validation
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(value)) {
              return ("Пожалуйста, введите действительный e-mail адрес");
            }
            return null;
          },
          onSaved: (value) {
            emailController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail,
                color: isMailFiledFocus
                    ? Color.fromRGBO(12, 194, 98, 1)
                    : Color.fromARGB(143, 124, 124, 124)),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Ваш e-mail адрес",
            hintStyle: TextStyle(
                fontFamily: "Inter",
                fontSize: 18,
                color: Color.fromARGB(143, 124, 124, 124)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color.fromARGB(255, 229, 229, 229)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color.fromRGBO(12, 194, 98, 1)),
            ),
          ),
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isMailFiledFocus = true;
            });
          } else {
            setState(() {
              isMailFiledFocus = false;
            });
          }
        },
      ),
    );

    //password field
    final passwordField = Focus(
        child: TextFormField(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            autofocus: false,
            controller: passwordController,
            obscureText: true,
            validator: (value) {
              RegExp regex = RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Для входа в систему требуется пароль");
              }
              if (!regex.hasMatch(value)) {
                return ("Введите допустимый пароль (мин. 6 символов)");
              }
              return null;
            },
            onSaved: (value) {
              passwordController.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key,
                    color: isPassFiledFocus
                        ? Color.fromRGBO(12, 194, 98, 1)
                        : Color.fromARGB(143, 124, 124, 124)),
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Пароль",
                hintStyle: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 18,
                    color: Color.fromARGB(143, 124, 124, 124)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 229, 229, 229)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(12, 194, 98, 1)),
                ))),
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isPassFiledFocus = true;
            });
          } else {
            setState(() {
              isPassFiledFocus = false;
            });
          }
        });

    final loginButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      color: Color.fromRGBO(12, 194, 98, 1),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Войти",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(19.2),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 150,
                        child: Image.asset(
                          "assets/Logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 35),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 25),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPassword()));
                            },
                            child: Text(
                              "Забыли пароль?",
                              style: TextStyle(
                                  color: Color.fromRGBO(16, 93, 56, 1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Inter",
                                  fontSize: 16),
                            ),
                          )
                        ]),
                    SizedBox(height: 25),
                    loginButton,
                    SizedBox(height: 25),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Нет аккаунта?  ",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Inter",
                                color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            child: Text(
                              "Зарегистрироваться",
                              style: TextStyle(
                                  color: Color.fromRGBO(16, 93, 56, 1),
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          )
                        ]),
                    SizedBox(height: 25),
                    OutlineButton(
                        onPressed: () async {
                          await FirebaseServices().signInWithGoogle();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        child: Stack(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset("assets/google.png",
                                  height: 28, alignment: Alignment.centerLeft),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Войти через Google",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: "DMSans"),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        highlightedBorderColor: Colors.green,
                        color: Colors.green,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        borderSide: new BorderSide(
                            color: Color.fromARGB(255, 220, 220, 220)),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
