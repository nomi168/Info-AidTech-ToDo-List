import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_llist/Todo_list/Todo_list.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int timerCount = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors
    timer = Timer.periodic(Duration(seconds: 6), (timer) {
      // ignore: avoid_print

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Todo_List(),
        ),
      );
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 131, 224),
          ),
          child: const Center(
            child: Text(
              'To-Do List',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
