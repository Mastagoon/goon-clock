import 'package:flutter/material.dart';
import 'package:goonclock/components/clock_component.dart';
import 'package:goonclock/constants/colors.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color(primaryBackgroundColor),
        child: ClockView(),
      ),
    );
  }
}