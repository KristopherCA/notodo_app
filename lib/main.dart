import 'package:flutter/material.dart';

import 'notodo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blueGrey, buttonColor: Colors.blueGrey),
        debugShowCheckedModeBanner: false,
        title: 'NoToDo',
        home: NoToDo());
  }
}

class NoToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Things Not To Do!",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25.0),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: NoToDoScreen(),
    );
  }
}
