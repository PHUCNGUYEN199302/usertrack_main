

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usertrack_main/config/constants.dart';
import 'package:usertrack_main/custom/show_dialog.dart';
import 'package:usertrack_main/custom/switch_list_title.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:usertrack_main/sp_utils/sp_utils.dart';
import 'package:image_picker/image_picker.dart';







class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool sendSMS = false;
  bool sendContacts = false;
  bool sendLocation = false;
  bool sendHistory = false;
  String test = '';

  File? image;

  Future changeAvatar() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    String strFile = image!.path;
    final fileTem = File(strFile);
    setState(() {
      this.image = fileTem;
    });
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 45.0, right: 16.0, left: 16.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.blue,
                  child: ListTile(
                    onTap: () {},
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SpUtils.get(USER_NAME,initValue: 'PHUC NGUYEN'),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          SpUtils.get(GMAIL,initValue: 'phucgolkk02@gmail.com'),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500,fontSize: 12),
                        ),

                      ],
                    ),
                    leading: image != null ? Container(
                      width: 40,
                      height: 40,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.file(image!),
                    ):Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    trailing: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.blue,
                        ),
                        title: Text("Change User Name"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          CommonDialog.showDialogApp(context, "User Name",
                              eventCallBack: (String userName) => {
                              updateUserName(userName),
                          });
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey.shade300,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.mail,
                          color: Colors.blue,
                        ),
                        title: Text("Change Gmail"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          CommonDialog.showDialogApp(context, "Gmail",
                              eventCallBack: (String gmailValue) => {
                                updateGmail(gmailValue),
                              });

                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey.shade300,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.image,
                          color: Colors.blue,
                        ),
                        title: Text("Change Avatar"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          changeAvatar();
                        },
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Notification Settings",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),

              SwitchListTitle(
                  title: "Send Contacts",
                  eventCallBack: (value) => {
                        sendContacts = value,
                    SpUtils.put(SEND_CONTACTS, sendContacts),
              }),
              SwitchListTitle(
                  title: "Send Location",
                  eventCallBack: (value) => {
                        sendLocation = value,
                    SpUtils.put(SEND_LOCATION, sendLocation)

                  }),
              SwitchListTitle(
                title: "Send SMS",
                eventCallBack: (value) => {
                  sendSMS = value,
                  SpUtils.put(SEND_SMS, sendSMS)
                  //   CommonDialog.sendMail("baokimpg@gmail.com", "Send SMS"),
                },
              ),
              SwitchListTitle(
                  title: "Send Call History",
                  eventCallBack: (value) => {
                        sendHistory = value,
                    SpUtils.put(SEND_HISTORY, sendHistory)

                  }),
            ],
          ),
        ),
      ),
    );
  }

  void updateUserName(String userName) async{
    SpUtils.put('userName', userName);
    setState(() {
    });
  }

  void updateGmail(String gmail)async{
    SpUtils.put('gmail', gmail);
    setState(() {
    });
  }



}
