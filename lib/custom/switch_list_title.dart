import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchListTitle extends StatefulWidget {
  final String title;
  Function(bool)? eventCallBack;


  SwitchListTitle({required this.title, this.eventCallBack});

  @override
  _SwitchListTitleState createState() => _SwitchListTitleState();
}

class _SwitchListTitleState extends State<SwitchListTitle> {
  bool _v = false;

  @override
  Widget build(BuildContext context) {
    return  SwitchListTile(
      title: _v == false ? Text(widget.title):Text(widget.title,style: new TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )),
      activeColor: Colors.blue,
      contentPadding: const EdgeInsets.all(0),
      value:_v,
      onChanged: (value)=>setState((){
        _v=value;
        widget.eventCallBack!(value);
      }),

    );
  }

}
