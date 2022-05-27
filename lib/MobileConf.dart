import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/EnterOTP.dart';
import 'package:untitled/signup.dart';

import 'main.dart';

class ConMobile extends StatefulWidget {
  const ConMobile({Key key}) : super(key: key);

  @override
  State<ConMobile> createState() => _ConMobileState();
}

class _ConMobileState extends State<ConMobile> {
  TextEditingController Mnumber = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 120),
          color: Colors.redAccent.shade200,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Verify Your Number",
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
                    SizedBox(
                      height: 100,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 15,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextField(
                                  controller: Mnumber,
                                  keyboardType:TextInputType.phone,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    hintText: "Enter your Mobile Number",
                                    contentPadding: EdgeInsets.all(15),
                                  )),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EnterOTP(mobile: Mnumber.text,)));

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        child: Text("Send OTP"),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 70)),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
