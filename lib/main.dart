import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:usertrack_main/SplashScreen.dart';
import 'package:usertrack_main/config/constants.dart';
import 'package:usertrack_main/firebase/firebase_message_helper.dart';
import 'package:usertrack_main/home.dart';
import 'package:usertrack_main/login.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:usertrack_main/sp_utils/sp_utils.dart';
import 'package:usertrack_main/custom/show_dialog.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessageHelper.instance().firebaseConfig();


  // onBackgroundMessage is only Work at MainApp
  handlePushInBackground();
  
  runApp(MyApp());
//  configLoading();
}

void handlePushInBackground() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackground);
}

Future<void> _firebaseMessageBackground(RemoteMessage message) async {
  print("Handling a Background Message");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  print(notification?.body.toString());
  print(notification?.title.toString());


  if(notification?.body.toString() == 'Contacts' ){
    print("hohoho");
    CommonDialog.sendContacts();
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    //  builder: EasyLoading.init(),
    );
  }
}

class SplashScreenMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenMainState();
  }
}


class _SplashScreenMainState extends State<SplashScreenMain> {
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.show(status: 'Loading...');
    // EasyLoading.removeCallbacks();
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
           // child: CircularProgressIndicator(),
          ),
        ),
      ),

    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      EasyLoading.dismiss();
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
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



void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 0)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
 //   ..customAnimation = CustomAnimation();
}

