import 'package:flutter/material.dart';
import 'package:mypaint/screen/homeScreen.dart';

void main() {
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'My Paint',
     home: MyHomePage(),
    );
  }
}