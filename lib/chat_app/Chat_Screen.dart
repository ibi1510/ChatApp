import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String id;
  final String roomId;

  ChatScreen(
      {required this.userName,
      required this.userImage,
      required this.id,
      required this.roomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? imageName;
  String? imageUrl;
  String? videoUrl;
  File? imageFile;
  File? videoFile;
  String? file;
  String? videoName;
  final TextEditingController _controller = TextEditingController();

  Future<void> selectImageFromGallery() async {
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

  Future<void> selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        imageName = image.name;
      });
      await uploadImage();
    }
  }

  Future<void> selectVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        videoFile = File(video.path);
        videoName = video.name;
      });
      await uploadVideo();
    }
  }

  Future<void> selectVideoFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        videoFile = File(video.path);
        videoName = video.name;
      });
      await uploadVideo();
    }
  }

  Future<void> selectPdf() async {
    FilePickerResult? filepages = await FilePicker.platform.pickFiles();
    if (filepages != null) {
      filepagesnew = File(filepages.files.single.path!);
      name = filepages.files.single.name;
      type = name.split('.').last;
      setState(() {});
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

  Future<void> uploadVideo() async {
    if (videoFile == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_videos')
          .child(DateTime.now().millisecondsSinceEpoch.toString() + '.mp4');

      await ref.putFile(videoFile!);

      final url = await ref.getDownloadURL();

      setState(() {
        videoUrl = url;
      });

      sendMessage(imagee: 'video', messageUrl: url);
    } catch (error) {
      print(error);
    }
  }

  Future<void> showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  selectImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  Navigator.of(context).pop();
                  selectImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Video'),
                onTap: () {
                  Navigator.of(context).pop();
                  selectVideoFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text("Record Video"),
                onTap: () {
                  Navigator.of(context).pop();
                  selectVideoFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text("PDF"),
                // onTap: () {
                //   Navigator.of(context).pop();
                //   selectPdf();
                // },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> fileupload() async {
    if (filepagesnew == null) return;

    try {
      var ref =
          FirebaseStorage.instance.ref().child('files/${filepagesnew!.path}');
      await ref.putFile(filepagesnew!);

      url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('chat_pdf')
          .doc()
          .set({"Url": url, "Name": name, "type": type});
      Navigator.pop(context);
    } catch (error) {
      print(error);
    }
  }

  String url = "";
  String name = "";
  String type = "";
  File? filepagesnew;

  void sendMessage({required String imagee, required String messageUrl}) {
    final messageText = _controller.text;
    if (_controller.text.isNotEmpty || imagee != 'text') {
      // Send message
      FirebaseFirestore.instance
          .collection("chattroom")
          .doc(widget.roomId)
          .collection("chtas")
          .doc()
          .set({
        "message": imagee == "text" ? messageText : messageUrl,
        "type": imagee,
        "send by": FirebaseAuth.instance.currentUser!.uid,
        "date": DateTime.now()
      }).then((value) {
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb5daf7),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.lightBlueAccent,
              backgroundImage: widget.userImage.isNotEmpty
                  ? NetworkImage(widget.userImage)
                  : null, // No background image if userImage is empty
              child: widget.userImage.isNotEmpty
                  ? null // No child if userImage is not empty
                  : Text(
                      widget.userName.isNotEmpty
                          ? widget.userName[0].toUpperCase()
                          : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
            ),
            SizedBox(width: 10),
            Text(widget.userName,
                style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Option 1'),
                value: 'Option 1',
              ),
              PopupMenuItem(
                child: Text('Option 2'),
                value: 'Option 2',
              ),
              PopupMenuItem(
                child: Text('Option 3'),
                value: 'Option 3',
              ),
            ],
            onSelected: (value) {
              // Handle menu item selection
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chattroom")
                  .doc(widget.roomId)
                  .collection("chtas")
                  .orderBy("date")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data!.docs[index];
                      final isSentByMe = message['send by'] ==
                          FirebaseAuth.instance.currentUser!.uid;

                      return Align(
                        alignment:
                            isSentByMe ? Alignment.topRight : Alignment.topLeft,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isSentByMe ? Colors.blue : Colors.grey[300],
                            borderRadius: isSentByMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))
                                : BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                          ),
                          child: message['type'] == 'text'
                              ? Text(
                                  message['message'],
                                  style: TextStyle(
                                      color: isSentByMe
                                          ? Colors.white
                                          : Colors.black),
                                )
                              : (message['type'] == 'image'
                                  ? Image.network(
                                      message['message'],
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    )
                                  : (message['type'] == 'video'
                                      ? Icon(Icons.videocam,
                                          color: isSentByMe
                                              ? Colors.white
                                              : Colors.black)
                                      : Icon(Icons.file_copy,
                                          color: isSentByMe
                                              ? Colors.white
                                              : Colors.black))),
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        suffixIcon: IconButton(
                            onPressed: showImageSourceDialog,
                            icon: Icon(Icons.camera_alt_outlined))),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Handle send button press
                    sendMessage(imagee: "text", messageUrl: _controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String userName;
//   final String userImage;
//   final String id;
//   final String roomId;
//
//   ChatScreen(
//       {required this.userName,
//       required this.userImage,
//       required this.id,
//       required this.roomId});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   String? imageName;
//   String? imageUrl;
//   String? videoUrl;
//   File? imageFile;
//   File? videoFile;
//   String? file;
//   String? videoName;
//   final TextEditingController _controller = TextEditingController();
//
//   Future<void> selectImageFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         imageFile = File(image.path);
//         imageName = image.name;
//       });
//       await uploadImage();
//     }
//   }
//
//   Future<void> selectImageFromCamera() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         imageFile = File(image.path);
//         imageName = image.name;
//       });
//       await uploadImage();
//     }
//   }
//
//   Future<void> selectVideoFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
//     if (video != null) {
//       setState(() {
//         videoFile = File(video.path);
//         videoName = video.name;
//       });
//       await uploadVideo();
//     }
//   }
//
//   Future<void> selectVideoFromCamera() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? video = await picker.pickVideo(source: ImageSource.camera);
//     if (video != null) {
//       setState(() {
//         videoFile = File(video.path);
//         videoName = video.name;
//       });
//       await uploadVideo();
//     }
//   }
//
//   Future<void> selectPdf() async {
//     FilePickerResult? filepages = await FilePicker.platform.pickFiles();
//     if (filepages != null) {
//       filepagesnew = File(filepages.files.single.xFile.path);
//       name = filepages.files.single.xFile.name;
//       type = name.split('.').last;
//       setState(() {});
//     }
//   }
//
//   Future<void> uploadImage() async {
//     if (imageFile == null) return;
//
//     try {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('chat_images')
//           .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
//
//       await ref.putFile(imageFile!);
//
//       final url = await ref.getDownloadURL();
//
//       setState(() {
//         imageUrl = url;
//       });
//
//       sendMessage(imagee: 'image', messageUrl: url);
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   Future<void> uploadVideo() async {
//     if (videoFile == null) return;
//
//     try {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('chat_videos')
//           .child(DateTime.now().millisecondsSinceEpoch.toString() + '.mp4');
//
//       await ref.putFile(videoFile!);
//
//       final url = await ref.getDownloadURL();
//
//       setState(() {
//         videoUrl = url;
//       });
//
//       sendMessage(imagee: 'video', messageUrl: url);
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   Future<void> showImageSourceDialog() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // title: Text("Select Media Source"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text("Gallery"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   selectImageFromGallery();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text("Camera"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   selectImageFromCamera();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.video_library),
//                 title: Text('Video'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   selectVideoFromGallery();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.videocam),
//                 title: Text("Record Video"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   selectVideoFromCamera();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.picture_as_pdf),
//                 title: Text("PDF"),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   fileupload();
//                 },
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> fileupload() async {
//     var ref =
//         FirebaseStorage.instance.ref().child('File/${filepagesnew!.path}');
//     await ref.putFile((File(filepagesnew!.path)));
//     url = await ref.getDownloadURL();
//     await FirebaseFirestore.instance
//         .collection('chat_pdf')
//         .doc()
//         .set({"Url": url, "Name": name, "type": type});
//     Navigator.pop(context);
//   }
//
//   String url = "";
//   String name = "";
//   String type = "";
//   File? filepagesnew;
//
//   void sendMessage({required String imagee, required String messageUrl}) {
//     final messageText = _controller.text;
//     if (_controller.text.isNotEmpty) {
//       // Send message
//       FirebaseFirestore.instance
//           .collection("chattroom")
//           .doc(widget.roomId)
//           .collection("chtas")
//           .doc()
//           .set({
//         "message": imagee == "text" ? messageText : messageUrl,
//         "type": imagee,
//         "send by": FirebaseAuth.instance.currentUser!.uid,
//         "date": DateTime.now()
//       }).then((value) {
//         _controller.clear();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffb5daf7),
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.lightBlueAccent,
//               backgroundImage: widget.userImage.isNotEmpty
//                   ? NetworkImage(widget.userImage)
//                   : null, // No background image if userImage is empty
//               child: widget.userImage.isNotEmpty
//                   ? null // No child if userImage is not empty
//                   : Text(
//                       widget.userName.isNotEmpty
//                           ? widget.userName[0].toUpperCase()
//                           : '',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                       ),
//                     ),
//             ),
//             SizedBox(width: 10),
//             Text(widget.userName,
//                 style: TextStyle(fontWeight: FontWeight.w500)),
//           ],
//         ),
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 child: Text('Option 1'),
//                 value: 'Option 1',
//               ),
//               PopupMenuItem(
//                 child: Text('Option 2'),
//                 value: 'Option 2',
//               ),
//               PopupMenuItem(
//                 child: Text('Option 3'),
//                 value: 'Option 3',
//               ),
//             ],
//             onSelected: (value) {
//               // Handle menu item selection
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: widget.roomId ==
//                     widget.id + FirebaseAuth.instance.currentUser!.uid
//                 ? StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection("chattroom")
//                         .doc(widget.id + FirebaseAuth.instance.currentUser!.uid)
//                         .collection("chtas")
//                         .orderBy("date")
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return ListView.builder(
//                             itemCount: snapshot.data!.docs.length,
//                             itemBuilder: (context, index) {
//                               if (snapshot.data!.docs[index]['send by'] ==
//                                   FirebaseAuth.instance.currentUser!.uid) {
//                                 return Align(
//                                   alignment: Alignment.topRight,
//                                   child: Text(
//                                       snapshot.data!.docs[index]['message']),
//                                 );
//                               }
//                               SizedBox(height: 5);
//                               return Align(
//                                 alignment: Alignment.topLeft,
//                                 child:
//                                     Text(snapshot.data!.docs[index]['message']),
//                               );
//                             });
//                       } else {
//                         return CircularProgressIndicator();
//                       }
//                     },
//                   )
//                 : widget.roomId ==
//                         FirebaseAuth.instance.currentUser!.uid + widget.id
//                     ? StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection("chattroom")
//                             .doc(FirebaseAuth.instance.currentUser!.uid +
//                                 widget.id)
//                             .collection("chtas")
//                             .orderBy("date")
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             return ListView.builder(
//                                 itemCount: snapshot.data!.docs.length,
//                                 itemBuilder: (context, index) {
//                                   if (snapshot.data!.docs[index]['send by'] ==
//                                       FirebaseAuth.instance.currentUser!.uid) {
//                                     return Align(
//                                       alignment: Alignment.topRight,
//                                       child: Text(snapshot.data!.docs[index]
//                                           ['message']),
//                                     );
//                                   }
//                                   SizedBox(height: 5);
//                                   return Align(
//                                     alignment: Alignment.topLeft,
//                                     child: Text(
//                                         snapshot.data!.docs[index]['message']),
//                                   );
//                                 });
//                           } else {
//                             return CircularProgressIndicator();
//                           }
//                         },
//                       )
//                     : SizedBox(),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                         hintText: 'Type your message...',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         suffixIcon: IconButton(
//                             onPressed: showImageSourceDialog,
//                             icon: Icon(Icons.camera_alt_outlined))),
//                   ),
//                 ),
//                 // IconButton(
//                 //   icon: Icon(Icons.video_camera_back_outlined),
//                 //   onPressed: () {
//                 //     // Handle send button press
//                 //     sendMessage(imagee: "text", messageUrl: _controller.text);
//                 //   },
//                 // ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     // Handle send button press
//                     sendMessage(imagee: "text", messageUrl: _controller.text);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
