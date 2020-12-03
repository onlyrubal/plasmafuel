import 'package:flutter/material.dart';

class PrimaryOutlineFilter extends StatefulWidget {
  final btnText;
  PrimaryOutlineFilter({this.btnText});
  @override
  _PrimaryOutlineFilterState createState() => _PrimaryOutlineFilterState();
}

class _PrimaryOutlineFilterState extends State<PrimaryOutlineFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 0,
        ),
      ),
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
