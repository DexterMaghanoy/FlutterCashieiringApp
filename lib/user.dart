import 'package:flutter/material.dart';
import 'package:flutterproject/sales.dart';

class ScanCodePage extends StatelessWidget {
  const ScanCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue, // Customize the background color
            ),
            SizedBox(height: 20),
            Text(
              'User', // Add the user's name here
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

    );
  }
}
