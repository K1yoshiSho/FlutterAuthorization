// ignore_for_file: prefer_const_constructors, deprecated_member_use, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login.dart';
import 'package:sanaly/services/firebase_serv.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Добро пожаловать!",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
              // SizedBox(
              //     height: 150,
              //     child: Image.asset(
              //       "assets/Logo.png",
              //       fit: BoxFit.contain,
              //     )),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 20),

              Text(
                "Привет, ${loggedInUser.fullName}!",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter"),
              ),
              SizedBox(height: 20),
              // Text("${loggedInUser.email}",
              //     style: TextStyle(
              //       color: Colors.black54,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500,
              //     )),
              OutlineButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Stack(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Выйти с учетной записи",
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
                  padding: EdgeInsets.symmetric(vertical: 15),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 220, 220, 220)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
