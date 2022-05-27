import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main.dart';

import 'authentication.dart';

class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController Email = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 120),
          color: Colors.black54,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Sing Up",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Welcome ",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Padding(padding: EdgeInsets.all(10)),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 15,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 300,
                            child: TextField(
                                controller: Email,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  contentPadding: EdgeInsets.all(15),
                                )),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextField(
                                controller: pass,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  contentPadding: EdgeInsets.all(15),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          _signup(Email.text, pass.text);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black54,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        child: Text("Singup"),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 70)),
                    RichText(
                      text: TextSpan(
                        text: "Do you alredy have account ? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: " Login",
                              style: TextStyle(color: Colors.red),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _signup(email, password) {
    print(email);
    print(password);
    AuthenticationHelper()
        .signUp(email: email, password: password)
        .then((result) {
      print("firebase_result $result");
      if (result == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    });
  }
}
