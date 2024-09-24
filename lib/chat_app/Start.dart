import 'package:chat_app/chat_app/Sign_in_page.dart';
import 'package:chat_app/chat_app/Welcome_Main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  // void initState() {
  //   super.initState();
  //   _checkLoginStatus();
  // }
  //
  // Future<void> _checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //
  //   if (isLoggedIn) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => UserListScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffb5daf7),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 120, top: 90),
                child: Text("Hello! Soldiers",
                    style: TextStyle(
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 150,
              ),
              Container(
                height: 200,
                width: 300,
                // color: Colors.blue,
                child: Lottie.asset("assets/Animations/welcome.json",
                    fit: BoxFit.fitWidth),
              ),
              SizedBox(
                height: 250,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninPage(),
                        ));
                  },
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.lightBlueAccent),
                      fixedSize: MaterialStatePropertyAll(Size(250, 55))),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              color: Colors.white)),
                      Icon(Icons.keyboard_double_arrow_right)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
