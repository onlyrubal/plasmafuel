import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings_page';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('User Account Settings'),
      ),
    );
  }
}
