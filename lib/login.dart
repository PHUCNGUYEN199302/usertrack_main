import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usertrack_main/config/constants.dart';
import 'package:usertrack_main/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usertrack_main/sp_utils/sp_utils.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController gmailController = TextEditingController();
  bool isCanClickLogin = false;

  @override
  void initState() {
    userNameController.addListener(() {
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]")
          .hasMatch(gmailController.text);
      if (emailValid) {
        isCanClickLogin = (userNameController.text.isNotEmpty &&
                gmailController.text.isNotEmpty)
            ? true
            : false;
      }
    });

    gmailController.addListener(() {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(gmailController.text);
      if (emailValid) {
        isCanClickLogin = (userNameController.text.isNotEmpty &&
                gmailController.text.isNotEmpty)
            ? true
            : false;
      }
    });
  }

  void clickLogin() async {
    final userName = userNameController.text;
    final gmail = gmailController.text;

    Navigator.pushReplacement(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => Home()),
    );

    // Save Login Success
    SpUtils.put(IS_LOGGED_IN, true);

    // Save UserName and Gmail
    SpUtils.put(USER_NAME, userName);
    SpUtils.put(GMAIL, gmail);
  }

  void showError() {
    Fluttertoast.showToast(
        msg: "Invalid Email Address",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OXA Login | theuicode.com",
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            color: Colors.blue.shade100,
            width: double.infinity,
            child: Column(
              children: [
                _logo(),
                _logoText(),
                _inputField(
                    Icon(Icons.person_outline,
                        size: 40, color: Color(0xffA6B0BD)),
                    "Username",
                    false,
                    userNameController),
                _inputField(
                    Icon(Icons.mail_outline,
                        size: 30, color: Color(0xffA6B0BD)),
                    "Gmail",
                    false,
                    gmailController),
                _loginBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
              left: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff00bfdb),
                ),
              )),
          Positioned(
              child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff008FFF),
            ),
          )),
          Positioned(
              left: 50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff00227E),
                ),
              )),
        ],
      ),
    );
  }

  Widget _logoText() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Text(
        "UMoni",
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          textStyle: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            color: Color(0xff000912),
            letterSpacing: 10,
          ),
        ),
      ),
    );
  }

  Widget _inputField(Icon prefixIcon, String hintText, bool isPassword,
      TextEditingController mController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: mController,
        obscureText: isPassword,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff000912),
          ),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 25),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(
            minWidth: 75,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20, bottom: 100),
      decoration: BoxDecoration(
          color: Color(0xff008FFF),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Color(0x60008FFF),
              blurRadius: 10,
              offset: Offset(0, 5),
              spreadRadius: 0,
            ),
          ]),
      child: MaterialButton(
        onPressed: () => isCanClickLogin ? clickLogin() : showError(),
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Text(
          "SIGN IN",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
    );
  }
}
