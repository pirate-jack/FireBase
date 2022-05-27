import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:untitled/signup.dart';


class EnterOTP extends StatefulWidget {
  final String mobile;

  const EnterOTP({
    Key key,
    this.mobile,
  }) : super(key: key);

  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  TextEditingController otp = TextEditingController();
  bool otp_validate;
  String otp_error;
  String fcmId;
  String currentText = "";
  String mobile;
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReceived = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    mobile = widget.mobile;
    otp_validate = false;
    otp_error = "";
    verifyNumber("OTP sent successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 80, left: 15, right: 15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Verify Mobile Number",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 50,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "OTP",
                      style: TextStyle(color: Colors.blue),
                    )),
                SizedBox(
                  height: 25,
                ),
                mainTextField(otp),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Change Number",
                          style:
                          TextStyle(fontSize: 15, color: Colors.blue),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          verifyNumber("OTP resent successfully");
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                                fontSize: 15, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                    height: 45,
                    width: 140,
                    child: ElevatedButton(
                        onPressed: () {
                          if (validate() == 0) {
                            /* Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword()));*/
                            verifyCode();
                          }
                        },
                        child: Text("Submit"))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainTextField(TextEditingController controller) {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      backgroundColor: Colors.white,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.red.withOpacity(0.5),
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.red.withOpacity(0.2),
          inactiveColor: Colors.red.shade200,
          selectedColor: Colors.red.shade200,
          activeColor: Colors.blue,
          errorBorderColor: Colors.red),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      controller: controller,
      keyboardType: TextInputType.number,
      onSubmitted: (v) {
        debugPrint("Completed");
        verifyCode();
      },
      onChanged: (value) {
        debugPrint(value);
        setState(() {
          currentText = value;
        });
      },
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
    );
  }

  int validate() {
    int cnt = 0;
    if (otp.text.isEmpty) {
      setState(() {
        otp_validate = true;
        otp_error = "Enter OTP";
      });
      cnt++;
    } else {
      otp_validate = false;
      otp_error = "";
    }
    return cnt;
  }

  void verifyNumber(String message) {
    auth.verifyPhoneNumber(
        phoneNumber: "+91" + mobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Signup()));
              print("success");
              print("user Logged in");
            }
          });
        },
        verificationFailed: (FirebaseException exception) {
          print("verificationFailed");
          print(exception.message);
        },
        codeSent: (String verificationID, int resendToken) {
          print("codeSent");
          setState(() {
            verificationIDReceived = verificationID;
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            verificationIDReceived = verificationID;
          });
        });
  }

  void verifyCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived, smsCode: currentText);
    try {
      await auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Signup()));
          print("success");
          print("getValue$value");
        }
      });
    } catch (e1) {
      print("yassssssh $e1");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Code Please Resend code and try again")));
    }
  }
}
