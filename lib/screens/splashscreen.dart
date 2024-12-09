// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:my_pocket_wallet/screens/loginscreen.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.blue.shade500,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(child: _topImageSection()),
          _middleScreenText(),
          _spashButton(context),
        ],
      ),
    ));
  }
}

Widget _topImageSection() {
  return Container(
    child: Center(child: Image.asset("assets/images/splash.png")),
  );
}

Widget _middleScreenText() {
  return Container(
    child: const Column(
      children: [
        Text("User Sunday"),
        SizedBox(
          height: 16,
        ),
        Text("Welcome to blur blur...."),
      ],
    ),
  );
}


Widget _spashButton(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          side: BorderSide(
            width: 2.0,
          ),
        ),
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    ],
  );
}
