import 'package:flutter/material.dart';

class DisplayProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String imageUrl;

  DisplayProfileScreen({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageUrl == ""
                ? CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.person,
                      size: 80,
                    ),
                  )
                : CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(imageUrl.toString()),
                  ),
            SizedBox(
              height: 20,
            ),
            TextField(
              // enabled: false,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              controller: TextEditingController(text: name),
            ),
            SizedBox(height: 20),
            TextField(
              // enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              controller: TextEditingController(text: email),
            ),
            SizedBox(height: 20),
            TextField(
              // enabled: false,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              controller: TextEditingController(text: phoneNumber),
            ),
          ],
        ),
      ),
    );
  }
}
