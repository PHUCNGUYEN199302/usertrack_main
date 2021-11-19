import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  TextEditingController textEditingController = new TextEditingController();

  String title;
  Function(String)? eventCallBack;

  DialogWidget({required this.title, required this.eventCallBack});


  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Input "+widget.title),
      content: TextField(
        controller: widget.textEditingController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: 'Enter ' + widget.title),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        Row(
          children: <Widget>[
            new TextButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(onPressed: () {
              widget.eventCallBack!(widget.textEditingController.text);
              Navigator.of(context).pop();
            }, child: new Text("OK"))
          ],
        ),
      ],
    );
  }
}
