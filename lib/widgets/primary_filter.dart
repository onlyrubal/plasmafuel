import 'package:flutter/material.dart';

class PrimaryFilter extends StatefulWidget {
  final btnText;
  PrimaryFilter({this.btnText});
  @override
  _PrimaryFilterState createState() => _PrimaryFilterState();
}

class _PrimaryFilterState extends State<PrimaryFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
