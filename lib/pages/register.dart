// ignore_for_file: unnecessary_new, prefer_const_constructors, body_might_complete_normally_nullable, deprecated_member_use, avoid_print

import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';
import 'home.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();

  final fullNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final checkBoxController = new Bool();
  bool isChecked = false;
  bool value = false;
  bool isNameFiledFocus = false;
  bool isMailFiledFocus = false;
  bool isPassFiledFocus = false;
  bool isRePassFiledFocus = false;

  @override
  Widget build(BuildContext context) {
    final Focus fullNameField;
    Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.green,
        ),
        child: fullNameField = Focus(
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: false,
              controller: fullNameEditingController,
              keyboardType: TextInputType.name,
              validator: (value) {
                RegExp regex = new RegExp(r'^.{3,}$');
                if (value!.isEmpty) {
                  return ("Имя не может быть пустым");
                }
                if (!regex.hasMatch(value)) {
                  return ("Введите действительное имя (мин. 3 символа)");
                }
                return null;
              },
              onSaved: (value) {
                fullNameEditingController.text = value!;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle,
                    color: isNameFiledFocus
                        ? Color.fromRGBO(12, 194, 98, 1)
                        : Color.fromARGB(143, 124, 124, 124)),
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Ваше ФИО",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 229, 229, 229)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(12, 194, 98, 1)),
                ),
              )),
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                isNameFiledFocus = true;
              });
            } else {
              setState(() {
                isNameFiledFocus = false;
              });
            }
          },
        ));

    //email field
    final Focus emailField;
    emailField = Focus(
      child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: false,
          controller: emailEditingController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Пожалуйста, введите ваш e-mail адрес");
            }
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(value)) {
              return ("Please Enter a valid email");
            }
            return null;
          },
          onSaved: (value) {
            fullNameEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail,
                color: isMailFiledFocus
                    ? Color.fromRGBO(12, 194, 98, 1)
                    : Color.fromARGB(143, 124, 124, 124)),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Ваш e-mail",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color.fromARGB(255, 229, 229, 229)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color.fromRGBO(12, 194, 98, 1)),
            ),
          )),
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
    );

    //password field
    final Focus passwordField;
    Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.green,
        ),
        child: passwordField = Focus(
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: false,
              controller: passwordEditingController,
              obscureText: true,
              validator: (value) {
                RegExp regex = new RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return ("Для входа в систему требуется пароль");
                }
                if (!regex.hasMatch(value)) {
                  return ("Введите действительный пароль (мин. 6 символов)");
                }
              },
              onSaved: (value) {
                fullNameEditingController.text = value!;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key,
                    color: isPassFiledFocus
                        ? Color.fromRGBO(12, 194, 98, 1)
                        : Color.fromARGB(143, 124, 124, 124)),
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Пароль",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 229, 229, 229)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(12, 194, 98, 1)),
                ),
              )),
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
          },
        ));

    //confirm password field
    final Focus confirmPasswordField;
    Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.green,
        ),
        child: confirmPasswordField = Focus(
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: false,
              controller: confirmPasswordEditingController,
              obscureText: true,
              validator: (value) {
                if (confirmPasswordEditingController.text !=
                    passwordEditingController.text) {
                  return "Пароли не совпадают";
                }
                if (value!.isEmpty) {
                  return ("Для входа в систему требуется пароль");
                }
                return null;
              },
              onSaved: (value) {
                confirmPasswordEditingController.text = value!;
              },
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key,
                    color: isRePassFiledFocus
                        ? Color.fromRGBO(12, 194, 98, 1)
                        : Color.fromARGB(143, 124, 124, 124)),
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Подтверждение пароля",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 229, 229, 229)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(12, 194, 98, 1)),
                ),
              )),
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                isRePassFiledFocus = true;
              });
            } else {
              setState(() {
                isRePassFiledFocus = false;
              });
            }
          },
        ));

    final signUpButton = Material(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Checkbox(
              value: isChecked,
              onChanged: (bool? val) {
                setState(() {
                  isChecked = val!;
                });
              },
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                child: Expanded(
                    child: Text.rich(TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        children: [
                      TextSpan(
                          text:
                              'Настоящим подтверждаю, что я ознакомлен с условиями ',
                          style: TextStyle(
                            fontFamily: "Inter",
                          )),
                      TextSpan(
                          text: "политикой конфиденциальности",
                          style: TextStyle(
                            color: Color.fromRGBO(16, 93, 56, 1),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              var url = "https://google.com";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }),
                    ]))),
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text("Зарегистрироваться",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter")),
              color: Color.fromRGBO(12, 194, 98, 1),
              disabledColor: Colors.grey,
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: isChecked ? ifCheckAccept : null,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 65,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              Text(
                "Регистрация",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
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
                        fullNameField,
                        SizedBox(height: 25),
                        emailField,
                        SizedBox(height: 25),
                        passwordField,
                        SizedBox(height: 25),
                        confirmPasswordField,
                        SizedBox(height: 25),
                        signUpButton,
                        SizedBox(height: 15),
                        // Row(mainAxisAlignment: MainAxisAlignment.center,
                        //     // ignore: prefer_const_literals_to_create_immutables
                        //     children: <Widget>[
                        //       Text(
                        //         "Или",
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             fontFamily: "Inter",
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.grey),
                        //       )
                        //     ]),
                        // SizedBox(height: 15),
                        // OutlineButton(
                        //     onPressed: () {},
                        //     child: Stack(
                        //       // ignore: prefer_const_literals_to_create_immutables
                        //       children: <Widget>[
                        //         Align(
                        //           alignment: Alignment.centerLeft,
                        //           child: Image.asset("assets/google.png",
                        //               height: 28,
                        //               alignment: Alignment.centerLeft),
                        //         ),
                        //         Align(
                        //             alignment: Alignment.center,
                        //             child: Text(
                        //               "Регистрация через Google",
                        //               style: TextStyle(
                        //                   color: Colors.black,
                        //                   fontSize: 18,
                        //                   fontFamily: "DMSans"),
                        //               textAlign: TextAlign.center,
                        //             ))
                        //       ],
                        //     ),
                        //     highlightedBorderColor: Colors.green,
                        //     color: Colors.green,
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 15, horizontal: 20),
                        //     borderSide: new BorderSide(
                        //         color: Color.fromARGB(255, 220, 220, 220)),
                        //     shape: new RoundedRectangleBorder(
                        //         borderRadius: new BorderRadius.circular(20.0))),
                        SizedBox(height: 25),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Уже есть аккаунт?  ",
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
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Войти",
                                  style: TextStyle(
                                      color: Color.fromRGBO(16, 93, 56, 1),
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              )
                            ]),
                        SizedBox(height: 25),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }

  void ifCheckAccept() {
    signUp(emailEditingController.text, passwordEditingController.text);
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
