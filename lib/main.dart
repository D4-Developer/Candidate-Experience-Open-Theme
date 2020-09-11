import 'authentication/signIn.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HR Management',
        debugShowCheckedModeBanner: false,
        home: signIn()
    );
  }
}