import 'package:chat_app/chat_app/Chat_Screen.dart';
import 'package:chat_app/chat_app/Own_Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

String search = "";

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  String chat = "";
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffb5daf7),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, bottom: 10, top: 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      print(search);
                      // _searchController.clear();
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffb5daf7),
                      labelText: "Search",
                      prefixIcon: IconButton(
                          onPressed: () {}, icon: Icon(Icons.search)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0))),
                ),
              ),
              _searchController.text.isEmpty
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .where(FieldPath.documentId,
                              isNotEqualTo:
                                  FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data!.docs.length);
                          int length = snapshot.data!.docs.length;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  chat = chatRoomId(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      snapshot.data!.docs[index].id);
                                  FirebaseFirestore.instance
                                      .collection("chattroom")
                                      .doc(chat)
                                      .set({
                                    "frinds": [
                                      FirebaseAuth.instance.currentUser!.uid,
                                      snapshot.data!.docs[index].id
                                    ],
                                    "dtae": DateTime.now(),
                                    "status": "",
                                    "first chat":
                                        FirebaseAuth.instance.currentUser!.uid,
                                    "recived chat":
                                        snapshot.data!.docs[index].id
                                  }).then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            roomId: chat,
                                            userName: snapshot.data!.docs[index]
                                                ['name'],
                                            userImage: snapshot
                                                .data!.docs[index]['image'],
                                            id: snapshot.data!.docs[index].id,
                                          ),
                                        ));
                                  });
                                },
                                title: Text(snapshot.data!.docs[index]['name']),
                                subtitle: Text(snapshot
                                    .data!.docs[index]['phone']
                                    .toString()),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            chat = chatRoomId(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                snapshot.data!.docs[index].id);
                                            FirebaseFirestore.instance
                                                .collection("chattroom")
                                                .doc(chat)
                                                .set({
                                              "frinds": [
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                snapshot.data!.docs[index].id
                                              ],
                                              "dtae": DateTime.now(),
                                              "status": "",
                                              "first chat": FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              "recived chat":
                                                  snapshot.data!.docs[index].id
                                            }).then((value) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                      roomId: chat,
                                                      userName: snapshot.data!
                                                          .docs[index]['name'],
                                                      userImage: snapshot.data!
                                                          .docs[index]['image'],
                                                      id: snapshot
                                                          .data!.docs[index].id,
                                                    ),
                                                  ));
                                            });
                                          },
                                          icon: Icon(Icons.message_outlined)),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DisplayProfileScreen(
                                                    name: snapshot.data!
                                                        .docs[index]["name"],
                                                    phoneNumber: snapshot.data!
                                                        .docs[index]["phone"],
                                                    email: snapshot.data!
                                                        .docs[index]["mail"],
                                                    imageUrl: snapshot
                                                        .data!.docs[index].id,
                                                  ),
                                                ));
                                          },
                                          icon: Icon(Icons.person))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .snapshots(),
                      builder: (context, snapshot) {
                        print(snapshot.data!.docs.length);
                        int length = snapshot.data!.docs.length;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: length,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase()) ||
                                snapshot.data!.docs[index]['phone']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase())) {
                              return ListTile(
                                onTap: () {},
                                title: Text(snapshot.data!.docs[index]['name']),
                                subtitle: Text(snapshot
                                    .data!.docs[index]['phone']
                                    .toString()),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            String chat1 = chatRoomId(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                snapshot.data!.docs[index].id);
                                            FirebaseFirestore.instance
                                                .collection("chattroom")
                                                .doc(chat1)
                                                .set({
                                              "frinds": [
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                snapshot.data!.docs[index].id
                                              ],
                                              "dtae": DateTime.now(),
                                              "status": "",
                                              "first chat": FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              "recived chat":
                                                  snapshot.data!.docs[index].id
                                            }).then((value) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                      roomId: chat1,
                                                      userName: snapshot.data!
                                                          .docs[index]['name'],
                                                      userImage: snapshot.data!
                                                          .docs[index]['image'],
                                                      id: snapshot
                                                          .data!.docs[index].id,
                                                    ),
                                                  ));
                                            });
                                          },
                                          icon: Icon(Icons.message_outlined)),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DisplayProfileScreen(
                                                    name: snapshot.data!
                                                        .docs[index]["name"],
                                                    phoneNumber: snapshot.data!
                                                        .docs[index]["phone"],
                                                    email: snapshot.data!
                                                        .docs[index]["mail"],
                                                    imageUrl: snapshot
                                                        .data!.docs[index].id,
                                                  ),
                                                ));
                                          },
                                          icon: Icon(Icons.person))
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        );
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
