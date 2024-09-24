import 'package:chat_app/chat_app/EmptyPage.dart';
import 'package:chat_app/chat_app/OTPScreen.dart';
import 'package:chat_app/chat_app/Welcome_Main.dart';
import 'package:chat_app/chat_app/bottom_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddDetails.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController _otpcontroller = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      // Pop up the email list
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // get the credential
        AuthCredential credential = await GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        try {
          //use the credential to verify that email to log in
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          var as = await FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
          if (as.exists) {
            await _saveLoginState();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomScreen()));
          } else {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({
              'displayName': googleSignInAccount.displayName.toString(),
              'displayemail': googleSignInAccount.email.toString(),
              'photoUrl': googleSignInAccount.photoUrl.toString(),
              'sadsa': googleSignInAccount.id.toString(),
            }).then((value) async {
              await _saveLoginState();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDetails(
                      name: googleSignInAccount.displayName.toString(),
                      mail: googleSignInAccount.email.toString(),
                      phone: "",
                    ),
                  ));
            });
          }
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          print(snackBar);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkData();
    getData();
  }

  checkData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? phone = preferences.getString("phone");
    bool? log = preferences.getBool("Logged");
    if (log != true) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomScreen(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SigninPage(),
          ));
    }
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var phone = preferences.getString("phoone");
    print(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb5daf7),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100,
                width: 200,
                color: Color(0xffb5daf7),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                width: 200,
                color: Color(0xffb5daf7),
                child: Text(
                  'Sign in',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                width: 200,
                color: Color(0xffb5daf7),
                child: Text(
                  'Sign up Google / Phone',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: _otpcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    // suffix: Text("+91"),
                    prefixText: "+91 ",
                    hintText: "Mobile No",
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white))),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.setString("phone", "7402195990").then(
                      (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OTPScreen(phone_numb: _otpcontroller.text))));
                },
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    fixedSize: Size(250, 50),
                    backgroundColor: Colors.blue,
                    // shadowColor: Colors.red,
                    // overlayColor: MaterialStateProperty.all(Colors.purple),
                    side: BorderSide(
                        width: 2,
                        color: Colors.blue,
                        style: BorderStyle.values[1]),
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.greenAccent, width: 2)),
                    // foregroundColor: Colors.pink
                    enableFeedback: true,
                    elevation: 5),
              ),
            ),
            Container(
              child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  )),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            InkWell(
              onTap: () {
                googleSignIn(context);
              },
              child: Container(
                width: 250,
                height: 50,
                // color: Color(0xffffffff),
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 20),
                      height: 24,
                      width: 24,
                      child: Image(
                        image: AssetImage(
                          "assets/google.png",
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Text(
                      "Continue With Google ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            // Container(
            //   width: 250,
            //   height: 50,
            //   // color: Color(0xffffffff),
            //   decoration: BoxDecoration(
            //       color: Color(0xffffffff),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: Row(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.only(left: 10, right: 20),
            //         height: 24,
            //         width: 24,
            //         child: Image(
            //           image: AssetImage(
            //             "assets/phone.jpg",
            //           ),
            //           fit: BoxFit.cover,
            //           alignment: Alignment.centerLeft,
            //         ),
            //       ),
            //       Text(
            //         "Continue With Phone ",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 17),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 15,
            // ),
            // Container(
            //   width: 250,
            //   height: 50,
            //   // color: Color(0xffffffff),
            //   decoration: BoxDecoration(
            //       color: Color(0xffffffff),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: Row(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.only(left: 10, right: 20),
            //         height: 24,
            //         width: 24,
            //         child: Image(
            //           image: AssetImage(
            //             "assets/mail.png",
            //           ),
            //           fit: BoxFit.cover,
            //           alignment: Alignment.centerLeft,
            //         ),
            //       ),
            //       Text(
            //         "Continue With Mail ",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 17),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      )),
    );
  }
}
