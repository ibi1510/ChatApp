import 'package:chat_app/chat_app/AddDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'bottom_page.dart';

class OTPScreen extends StatefulWidget {
  String phone_numb;
  OTPScreen({super.key, required this.phone_numb});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String code = '';
  String smscode = '';
  String? _verificationCode;
  final TextEditingController _pinput = TextEditingController();

  verifyphonenumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${widget.phone_numb}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            final User? user = FirebaseAuth.instance.currentUser;
            final uid = user!.uid;
            print(">>>>>>>>>>>>>>>>${uid}");
            var im = await FirebaseFirestore.instance
                .collection("Users")
                .doc(uid)
                .get();
            if (im.exists) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BottomScreen();
                },
              ));
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return AddDetails(
                    name: "",
                    mail: "",
                    phone: widget.phone_numb,
                  );
                },
              ));
            }
          });
        },
        verificationFailed: (FirebaseAuthException s) {
          print(s);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("${s.message}"),
                );
              });
        },
        codeSent: (String? verification, int? resendToken) {
          setState(() {
            print(">>>>>>>>>>>>>>>>>>>>${verification}");
            _verificationCode = verification;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

  Future<void> submitOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationCode!, smsCode: _pinput.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final currentuser = FirebaseAuth.instance.currentUser;
      final snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentuser!.uid)
          .get();
      if (snapshot.exists) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return BottomScreen();
          },
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AddDetails(
              name: "",
              mail: "",
              phone: widget.phone_numb,
            );
          },
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyphonenumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb5daf7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    width: 200,
                    color: Color(0xffb5daf7),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 30,
                    width: 200,
                    // margin: EdgeInsets.only(top:40,left: 40,),
                    color: Color(0xffb5daf7),
                    child: Text(
                      "Welcome",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    width: 500,
                    // margin: EdgeInsets.only(top:40,left: 40,),
                    color: Color(0xffb5daf7),
                    child: Text(
                      "Sign up / Log in to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    width: 500,
                    // margin: EdgeInsets.only(top:40,left: 40,),
                    color: Color(0xffb5daf7),
                    child: Text(
                      "Enter the 6 digit OTP",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: _pinput,
                    onCompleted: (v) {
                      setState(() {
                        smscode = _pinput.text;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    width: 500,
                    // margin: EdgeInsets.only(top:40,left: 40,),
                    color: Color(0xffb5daf7),
                    child: Text(
                      "Didn't get the OTP? Resend OTP",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      submitOtp();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => AddDetails(
                      //           name: "name",
                      //           username: "username",
                      //           phone: widget.phone_numb),
                      //     ));
                    },
                    child: Text(
                      'Verify',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      // fixedSize: Size(300, 50),
                      backgroundColor: Colors.blue,
                      //shadowColor: Colors.red,
                      // overlayColor: MaterialStateProperty.all(Colors.purple),
                      side: BorderSide(
                          width: 2,
                          color: Colors.blue,
                          //  overlayColor: MaterialStateProperty.all(Colors.purple),
                          style: BorderStyle.values[1]),

                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.green, width: 2),
                      ),
                      // foregroundColor: Colors.pink,
                      enableFeedback: true,
                      elevation: 5,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
