import 'package:flutter/material.dart';

class PrimaryOutlineButton extends StatefulWidget {
  final btnText;
  PrimaryOutlineButton({this.btnText});
  @override
  _PrimaryOutlineButtonState createState() => _PrimaryOutlineButtonState();
}

class _PrimaryOutlineButtonState extends State<PrimaryOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: 2,
          )),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
