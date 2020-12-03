import 'package:flutter/material.dart';
import 'package:plasma_fuel/widgets/donor_item.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/donor_info.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings_page';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final _authenticatedUserId = Provider.of<Auth>(context).userId;
    final _mySubmissions =
        Provider.of<Donors>(context).mySubmissions(_authenticatedUserId);
    final _mySingleSubmission =
        Provider.of<Donors>(context).mySingleSubmission(_authenticatedUserId);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Container(
            child: Text(
              'Account Settings',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: new IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 30),
                child: GestureDetector(
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).signOut();
                  },
                  child: Icon(
                    Icons.logout,
                    size: 26.0,
                  ),
                )),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Are you available to donate'),
            value: _mySingleSubmission.isAvailable,
            onChanged: (newValue) {},
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'My Submissions (${Provider.of<Donors>(context).mySubmissionsCount(_authenticatedUserId)})',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (buildContext, index) => ChangeNotifierProvider.value(
              value: _mySubmissions[index],
              child: DonorItem(),
            ),
            itemCount: _mySubmissions.length,
          )
        ],
      ),
    );
  }
}
