import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usertrack_main/config/constants.dart';
import 'package:usertrack_main/home.dart';
import 'package:usertrack_main/login.dart';
import 'package:usertrack_main/sp_utils/sp_utils.dart';



class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  bool? _loadingInProgress;

  Animation<double>? _angleAnimation;
  Animation<double>? _scaleAnimation;
  AnimationController? _controller;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Center(
          child: Container(
            child: _buildAnimation(),
          ),
        ),
      ),
    );
  }


  void initAnimation(){
    _loadingInProgress = true;

    _controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _angleAnimation = new Tween(begin: 0.0, end: 360.0).animate(_controller!)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _scaleAnimation = new Tween(begin: 1.0, end: 6.0).animate(_controller!)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _angleAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_loadingInProgress!) {
          _controller!.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (_loadingInProgress!) {
          _controller!.forward();
        }
      }
    });

    _controller!.forward();

  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }



  Widget _buildAnimation() {
    double circleWidth = 10.0 * _scaleAnimation!.value;
    Widget circles = new Container(
      width: circleWidth * 2.0,
      height: circleWidth * 2.0,
      child: new Column(
        children: <Widget>[
          new Row (
            children: <Widget>[
              _buildCircle(circleWidth,Colors.blue),
              _buildCircle(circleWidth,Colors.red),
            ],
          ),
          new Row (
            children: <Widget>[
              _buildCircle(circleWidth,Colors.yellow),
              _buildCircle(circleWidth,Colors.green),
            ],
          ),
        ],
      ),
    );

    double angleInDegrees = _angleAnimation!.value;
    return new Transform.rotate(
      angle: angleInDegrees / 360 * 2 * 3.14,
      child: new Container(
        child: circles,
      ),
    );
  }

  Widget _buildCircle(double circleWidth, Color color) {
    return new Container(
      width: circleWidth,
      height: circleWidth,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 5), () {
      navigateUser();
      _loadingInProgress = false;//It will redirect  after 3 seconds
    });
  }

  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status =SpUtils.get(IS_LOGGED_IN, initValue: false);
    if (status) {
      Navigator.pushReplacement(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(builder: (context) => Home()),
      );

    // Naviga
    } else {
      Navigator.pushReplacement(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }
}
