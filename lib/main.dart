import 'dart:async';
import 'dart:io';

import 'package:esyitr/autofill.dart';
import 'package:esyitr/mobileNumber.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EzyITR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), () {
      if(Platform.isIOS){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MobileNUmber()));
      }
      if(Platform.isAndroid)
        {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AutoFill()));
        }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(173, 144, 239, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                'assets/esyitr.png',
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
            // Image.asset('assets/esyitr.png'),
            Container(
              child: Text(
                'EzyITR',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
