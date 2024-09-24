import 'package:chat_app/chat_app/Welcome_Main.dart';
import 'package:chat_app/chat_app/bottom_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddDetails extends StatefulWidget {
  String name;
  String mail;
  String phone;
  AddDetails(
      {Key? key, required this.name, required this.mail, required this.phone})
      : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  late TextEditingController name;
  late TextEditingController phoneNumber;
  TextEditingController username = TextEditingController();
  late TextEditingController mail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumber = TextEditingController(text: widget.phone);
    mail = TextEditingController(text: widget.mail);
    name = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb5daf7),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 250, top: 80),
                child: Text(
                  "Details",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                      hintText: "Enter name",
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
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                child: TextFormField(
                  controller: phoneNumber,
                  decoration: InputDecoration(
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
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                child: TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                      hintText: "Enter username",
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
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                child: TextFormField(
                  controller: mail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Enter mail",
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
                height: 80,
              ),
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({
                      'name': name.text,
                      'username': username.text,
                      'phone': phoneNumber.text,
                      'mail': mail.text,
                      "image": "",
                      'gender': "",
                      "age": ""
                    }).then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomScreen()));
                    });
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => Welcome(),
                    //     ));
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
                      Text("Contine",
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
