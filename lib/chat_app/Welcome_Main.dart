// // import 'package:chat_app/chat_app/Chat_Screen.dart';
// import 'package:chat_app/chat_app/Chat_Screen.dart';
// import 'package:chat_app/chat_app/Search_Screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class UserListScreen extends StatefulWidget {
//   const UserListScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UserListScreen> createState() => _UserListScreenState();
// }
//
// class _UserListScreenState extends State<UserListScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color(0xffb5daf7),
//         body: Column(
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     // setState(() { _isSearchExpanded = !_isSearchExpanded;});
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SearchScreen(),
//                         ));
//                   }),
//             ),
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection("chattroom")
//                     .where("frinds", arrayContainsAny: [
//                   FirebaseAuth.instance.currentUser!.uid
//                 ]).snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(
//                       child: Text('No users found.'),
//                     );
//                   }
//                   return ListView.builder(
//                     // padding: EdgeInsets.zero,
//                     physics: BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       String image = '';
//                       if (snapshot.data!.docs[index]
//                           .data()
//                           .containsKey("image")) {
//                         image = snapshot.data!.docs[index]['image'];
//                       }
//                       return StreamBuilder(
//                           stream: FirebaseFirestore.instance
//                               .collection("Users")
//                               .doc(snapshot.data!.docs[index]["first chat"] ==
//                                       FirebaseAuth.instance.currentUser!.uid
//                                   ? snapshot.data!.docs[index]["recived chat"]
//                                   : snapshot.data!.docs[index]["first chat"])
//                               .snapshots(),
//                           builder: (context, snap) {
//                             if (snap.hasData) {
//                               return Card(
//                                 child: ListTile(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => ChatScreen(
//                                             roomId:
//                                                 snapshot.data!.docs[index].id,
//                                             userName: snap.data!['name'],
//                                             userImage: snap.data!['image'],
//                                             id: snap.data!.id,
//                                           ),
//                                         ));
//                                   },
//                                   leading: image == ''
//                                       ? CircleAvatar(
//                                           radius: 40,
//                                           backgroundColor: index == 0
//                                               ? Colors.blue
//                                               : Colors.blueAccent,
//                                           child: Text(snap.data!['name'][0],
//                                               style: TextStyle(
//                                                   color: Colors.white)),
//                                         )
//                                       : CircleAvatar(
//                                           radius: 40,
//                                           backgroundImage: NetworkImage(image),
//                                         ),
//                                   title: Text(snap.data!['name'],
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w500)),
//                                   subtitle: Text(snap.data!['phone']),
//                                   trailing: IconButton(
//                                       onPressed: () {},
//                                       icon: Icon(
//                                           Icons.arrow_circle_right_outlined)),
//                                 ),
//                               );
//                             } else {
//                               return CircularProgressIndicator();
//                             }
//                           });
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:chat_app/chat_app/Chat_Screen.dart';
import 'package:chat_app/chat_app/Search_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffb5daf7),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chattroom")
                    .where("frinds", arrayContainsAny: [
                  FirebaseAuth.instance.currentUser!.uid
                ]).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('No users found.'),
                    );
                  }
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      String image = '';
                      if (snapshot.data!.docs[index]
                          .data()
                          .containsKey("image")) {
                        image = snapshot.data!.docs[index]['image'];
                      }
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(snapshot.data!.docs[index]["first chat"] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? snapshot.data!.docs[index]["recived chat"]
                                : snapshot.data!.docs[index]["first chat"])
                            .snapshots(),
                        builder: (context, snap) {
                          if (snap.hasData && snap.data != null) {
                            String name = snap.data?['name'] ?? 'Unknown';
                            String userImage = snap.data?['image'] ?? '';
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        roomId: snapshot.data!.docs[index].id,
                                        userName: name,
                                        userImage: userImage,
                                        id: snap.data!.id,
                                      ),
                                    ),
                                  );
                                },
                                leading: userImage.isEmpty
                                    ? CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                          name[0],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            NetworkImage(userImage),
                                      ),
                                title: Text(
                                  name,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                    snap.data?['phone'] ?? 'No phone number'),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_circle_right_outlined),
                                ),
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
