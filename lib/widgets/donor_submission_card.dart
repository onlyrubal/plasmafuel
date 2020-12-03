import 'package:flutter/material.dart';
import '../screens/donor_submission_screen.dart';
import '../providers/donor_info.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class DonorSubmissionCard extends StatelessWidget {
  String heading;
  String subHeading;
  String imageValue;
  DonorSubmissionCard({this.heading, this.subHeading, this.imageValue});

  @override
  Widget build(BuildContext context) {
    final donorInfoData = Provider.of<Donors>(context);
    final authID = Provider.of<Auth>(context).userId;
    final _hasSubmitted =
        (int.tryParse(donorInfoData.mySubmissionsCount(authID)) > 0)
            ? true
            : false;
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.redAccent.withOpacity(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageValue, height: 160, width: 160),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                _hasSubmitted ? 'Thanks for Submission' : heading,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 22),
              ),
            ),
            SizedBox(height: 5),
            if (!_hasSubmitted)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    subHeading,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 18),
                    softWrap: true,
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(DonorSubmissionScreen.routeName);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).accentColor,
                        ),
                        child: Icon(
                          Icons.arrow_forward_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
