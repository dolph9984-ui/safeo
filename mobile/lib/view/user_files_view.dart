import 'package:flutter/material.dart';

class UserFilesView extends StatelessWidget {
  const UserFilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Logged in!')],
        ),
      ),
    );
  }
}
