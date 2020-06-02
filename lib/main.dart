import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'Index.dart';
import 'SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          'index': (context) => Index(),
        },
        debugShowCheckedModeBanner: false,

        home: SplashScreen());
  }
}
