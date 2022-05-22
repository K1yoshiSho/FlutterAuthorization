// ignore_for_file: prefer_const_constructors, unnecessary_new, deprecated_member_use, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ResetPassword> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();

  bool isMailFiledFocus = false;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    bool isPasswordType = false;
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
          obscureText: isPasswordType,
          enableSuggestions: !isPasswordType,
          autocorrect: !isPasswordType,
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
            hintText: "Введите ваш e-mail",
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

    final resetButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      color: Color.fromRGBO(12, 194, 98, 1),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailController.text)
                .then((value) => Navigator.of(context).pop());
          },
          child: Text(
            "Сбросить пароль",
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
              "Сброс пароля",
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
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/synchronize.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 70),
                    emailField,
                    SizedBox(height: 25),
                    resetButton,
                    SizedBox(height: 55),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
