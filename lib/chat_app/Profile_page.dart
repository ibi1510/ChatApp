import 'dart:io';
import 'package:chat_app/chat_app/bottom_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? name;
  TextEditingController? phoneNumber;
  TextEditingController? username;
  TextEditingController? mail;
  TextEditingController? gender;
  TextEditingController? age;
  // @override

  String? imageName;
  String? imageUrl;
  File? imageFile;

  String aadharFilePath = "";
  File? imageAadhar;
  String aadhar = "";

  String? name1;
  String? mail1;
  String? username1;
  String? num;
  String? image1;

  String? url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    var s = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    name1 = s["name"];
    mail1 = s["mail"];
    username1 = s["username"];
    num = s["phone"];
    image1 = s['image'];

    name = TextEditingController(text: name1);
    username = TextEditingController(text: username1);
    phoneNumber = TextEditingController(text: num);
    mail = TextEditingController(text: mail1);
    gender = TextEditingController();
    age = TextEditingController();
    setState(() {});
  }

  bool upload = false;
  // void selectImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     imageFile = File(image.path);
  //     imageName = image.name;
  //     var ref = FirebaseStorage.instance.ref().child("Images/$imageName");
  //     await ref.putFile(imageFile!);
  //     imageUrl = await ref.getDownloadURL();
  //     setState(() {
  //       image1 = imageUrl;
  //     });
  //
  //   }
  // }
  // Future<void> uploadImage() async {
  //   if (imageFile != null) {
  //     var ref = FirebaseStorage.instance.ref().child("Images/$imageName");
  //     await ref.putFile(imageFile!);
  //     imageUrl = await ref.getDownloadURL();
  //     setState(() {
  //       image1 = imageUrl;
  //     });
  //   }
  // }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb5daf7),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flexible(child: Container(), flex: 2),
              SizedBox(height: 54),
              Stack(
                children: [
                  image1 == ""
                      ? Center(
                          child: CircleAvatar(
                            radius: 60,
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                          ),
                        )
                      : Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(image1.toString()),
                          ),
                        ),
                  Positioned(
                    bottom: -5,
                    right: 125,
                    child: IconButton(
                      onPressed: pickAadharImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
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
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
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
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
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
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
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
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: TextFormField(
                  controller: gender,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Enter gender",
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
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: TextFormField(
                  controller: age,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Enter age",
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
              ElevatedButton(
                  onPressed: upload == true
                      ? null
                      : () async {
                          setState(() {
                            upload = true;
                          });
                          // await pickAadharImage();
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'name': name!.text,
                            'username': username!.text,
                            'phone': phoneNumber!.text,
                            'mail': mail!.text,
                            'gender': gender!.text,
                            'age': age!.text,
                            'image': aadhar,
                            // 'imagename': imageName!
                          }).then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomScreen(),
                                  )));
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
                      Text("Save",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              color: Colors.white)),
                      Icon(Icons.keyboard_double_arrow_right)
                    ],
                  )),
              // Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an Account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  Container(
                    child: Text(
                      " Login",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickAadharImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      print("imageTemp ====? ${imageTemp}");
      aadharFilePath = basename(imageTemp.path);
      print("aadharFilePath ====? ${aadharFilePath}");
      setState(() => this.imageAadhar = imageTemp);
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();
      // Create a reference to "mountains.jpg"
      final mountainImagesRef =
          storageRef.child("AdminAadharImage/$aadharFilePath");
      await mountainImagesRef.putFile(imageTemp);
      String aadharurl = await mountainImagesRef.getDownloadURL();
      print(aadharurl);
      setState(() {
        aadhar = aadharurl;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
