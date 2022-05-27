import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled/MobileConf.dart';
import 'authentication.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("handling a background message${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance notification",
    "This channel is used fro important notification.",
    importance: Importance.high);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController Email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings("assets/noti.png");
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    icon: "launch_background")));
      }
    });
    getToken();
  }
  void getToken()async{
    String token = await FirebaseMessaging.instance.getToken();
    print("token");
    print(token);
    print("token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 120),
          color: Colors.green.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
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
                              height: 10,
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
                            login(Email.text, pass.text);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade200,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          child: Text("Login"),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 70)),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account ? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: " Sing up",
                                style: TextStyle(color: Colors.red),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ConMobile()));
                                  }),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "By Logging in you are agree with our",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: " Terms &",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Conditions ",
                          style: TextStyle(color: Colors.blue),
                          children: [
                            TextSpan(
                              text: "and ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: "Privacy policy",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(email, password) async {
    AuthenticationHelper()
        .signIn(email: email, password: password)
        .then((result) {
      if (result == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("success")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.toString())));
      }
    });
  }
}
