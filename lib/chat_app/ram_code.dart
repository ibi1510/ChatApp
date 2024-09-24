// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ChatScreendetail extends StatefulWidget {
//   final String name;
//   final String imageUrl;
//   final String id;
//
//   ChatScreendetail({
//     super.key,
//     required this.name,
//     required this.imageUrl,
//     required this.id
//   });
//
//   @override
//   State<ChatScreendetail> createState() => _ChatScreendetailState();
// }
//
// class _ChatScreendetailState extends State<ChatScreendetail> {
//   String? imageName;
//   String? imageUrl;
//   File? imageFile;
//   TextEditingController messageCon = TextEditingController();
//
//   @override
//   void selectImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       imageFile = File(image.path);
//       imageName = image.name;
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           CircleAvatar(
//             radius: 20,
//             backgroundImage: NetworkImage(widget.imageUrl),
//           ),
//           SizedBox(width: 10),
//           Text(widget.name),
//           Spacer(),
//           IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_sharp)),
//         ],
//         backgroundColor: Colors.green,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('chatroom')
//                   .doc(FirebaseAuth.instance.currentUser!.uid + widget.id)
//                   .collection('chats')
//                   .orderBy("date")
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       return snapshot.data!.docs[index]['send by'] ==
//                           FirebaseAuth.instance.currentUser!.uid
//                           ? Align(
//                         alignment: Alignment.topRight,
//                         child: Container(
//                           padding: const EdgeInsets.all(8.0),
//                           margin: const EdgeInsets.all(5.0),
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Text(
//                             snapshot.data!.docs[index]['message'],
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       )
//                           : Align(
//                         alignment: Alignment.topLeft,
//                         child: Container(
//                           padding: const EdgeInsets.all(8.0),
//                           margin: const EdgeInsets.all(5.0),
//                           decoration: BoxDecoration(
//                             color: Colors.purple,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Text(
//                             snapshot.data!.docs[index]['message'],
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(10.0),
//             color: Colors.grey.shade200,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(35.0),
//                       border: Border.all(color: Colors.green),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: messageCon,
//                             decoration: InputDecoration(
//                               hintText: "Type a message here...",
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: selectImage,
//                           icon: Icon(Icons.camera_alt_outlined),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundColor: Colors.green,
//                   child: IconButton(
//                     onPressed: () {
//                       if (messageCon.text.isNotEmpty) {
//                         FirebaseFirestore.instance
//                             .collection("chatroom")
//                             .doc(FirebaseAuth.instance.currentUser!.uid + widget.id)
//                             .collection('chats')
//                             .add({
//                           "message": messageCon.text,
//                           "type": "text",
//                           "send by": FirebaseAuth.instance.currentUser!.uid,
//                           "date": DateTime.now(),
//                         }).then((value) {
//                           messageCon.clear();
//                         });
//                       }
//                     },
//                     icon: Icon(
//                       Icons.send,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreendetail extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String id;
  final String chatroomid;

  ChatScreendetail({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.chatroomid,
  });

  @override
  State<ChatScreendetail> createState() => _ChatScreendetailState();
}

class _ChatScreendetailState extends State<ChatScreendetail> {
  String? imageName;
  String? imageUrl;
  File? imageFile;
  TextEditingController messageCon = TextEditingController();

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        imageName = image.name;
      });
      await uploadImage();
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');

      await ref.putFile(imageFile!);

      final url = await ref.getDownloadURL();

      setState(() {
        imageUrl = url;
      });

      sendMessage(imagee: 'image', messageUrl: url);
    } catch (error) {
      print(error);
    }
  }

  void sendMessage({required String imagee, required String messageUrl}) {
    if (messageUrl.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(FirebaseAuth.instance.currentUser!.uid + widget.id)
          .collection('chats')
          .add({
        "message": messageUrl,
        "type": imagee,
        "send by": FirebaseAuth.instance.currentUser!.uid,
        "date": DateTime.now(),
      }).then((value) {
        messageCon.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.imageUrl),
          ),
          SizedBox(width: 10),
          Text(widget.name),
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_sharp)),
        ],
        backgroundColor: Colors.green,
      ),
      body: Column(
          children: [
            Expanded(
              child: widget.chatroomid==widget.id + FirebaseAuth.instance.currentUser!.uid
                  ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc( widget.id+ FirebaseAuth.instance.currentUser!.uid )
                    .collection('chats')
                    .orderBy("date")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          if(snapshot.data!.docs[index]['send by']==
                              FirebaseAuth.instance.currentUser!.uid){
                            return Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                  snapshot.data!.docs[index]['message']),
                            );

                          }SizedBox(height: 5,);
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Text(snapshot.data!.docs[index]['message']),
                          );
                        }
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ):SizedBox(),
            ),
            Padding(padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageCon,
                      decoration: InputDecoration(
                        hintText: "Type a message here...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //

                  IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.camera_alt_outlined),
                  ),

                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      onPressed: () {
                        sendMessage(imagee: 'text', messageUrl: messageCon.text);
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),),
          ]),

    );
  }
}