// import 'package:chat_app/chat_app/Profile_page.dart';
// import 'package:chat_app/chat_app/Welcome_Main.dart';
// import 'package:flutter/material.dart';
//
// class BottomScreen extends StatefulWidget {
//   const BottomScreen({
//     super.key,
//   });
//
//   @override
//   State<BottomScreen> createState() => _BottomScreenState();
// }
//
// class _BottomScreenState extends State<BottomScreen> {
//   int currnIndex = 0;
//   List pages = [UserListScreen(), ProfileScreen()];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[currnIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Color(0xffb5daf7),
//         showUnselectedLabels: true,
//         unselectedItemColor: Colors.black45,
//         selectedItemColor: Colors.blue,
//         selectedIconTheme: IconThemeData(color: Colors.blue),
//         currentIndex: currnIndex,
//         onTap: (i) {
//           setState(() {
//             currnIndex = i;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.chat),
//               // backgroundColor: Colors.lightBlueAccent,
//               label: "Chat"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
//         ],
//       ),
//     );
//   }
// }


import 'package:chat_app/chat_app/Profile_page.dart';
import 'package:chat_app/chat_app/Welcome_Main.dart';
import 'package:flutter/material.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({
    super.key,
  });

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  int currnIndex = 0;
  List pages = [UserListScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currnIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffb5daf7),
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black45,
        selectedItemColor: Colors.blue,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        currentIndex: currnIndex,
        onTap: (i) {
          setState(() {
            currnIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
    );
  }
}
