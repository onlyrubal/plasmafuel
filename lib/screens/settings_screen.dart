import 'package:flutter/material.dart';
import 'package:plasma_fuel/widgets/donor_item.dart';
import 'package:plasma_fuel/widgets/secondary_button.dart';
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
    bool _checkDidChangeDependenciesRan = true;

    Donor _editedDonor;

    var _initDefaultDonorValues = {
      'donorName': '',
      'donorAddress': '',
      'donorGender': '',
      'donorAge': '',
      'donorContactNumber': '',
      'recordProof': '',
      'isAnonymous': false,
    };

    @override
    void didChangeDependencies() {
      if (_checkDidChangeDependenciesRan) {
        final donorId = Provider.of<Donors>(context)
            .mySubmissionDonorId(_authenticatedUserId);
        if (donorId != null) {
          _editedDonor = Provider.of<Donors>(context).findById(donorId);
        }
      }
    }

    bool _mySubmission = true;
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
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Available to donate ?'),
            value: _mySubmission,
            onChanged: (newValue) {
              setState(
                () {
                  // Filter value is changed here that we initialized earlier.
                  _mySubmission = newValue;
                },
              );
            },
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'My Profile',
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
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Provider.of<Auth>(context, listen: false).signOut();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SecondaryButton(
                btnText: 'Sign Out',
              ),
            ),
          )
        ],
      ),
    );
  }
}
