import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/donor_info.dart';
import '../providers/auth.dart';

class DonorItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final donor = Provider.of<Donor>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final _authenticatedUserId = auth.userId;
    final scaffold = Scaffold.of(context);

    return Container(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          margin: EdgeInsets.only(bottom: 40),
          color: donor.approveStatus == 'Approved'
              ? Colors.green[50]
              : (donor.approveStatus == 'Pending'
                  ? Colors.yellow[50]
                  : Colors.red[50]),
          // margin: EdgeInsets.all(30),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if ((_authenticatedUserId == donor.userId))
                  SizedBox(height: 10),
                if (!(_authenticatedUserId == donor.userId))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<Donor>(
                        builder: (context, donor, _) => IconButton(
                          color: Theme.of(context).accentColor,
                          icon: Icon(donor.isBookmarked
                              ? Icons.bookmark_sharp
                              : Icons.bookmark_border_sharp),
                          onPressed: () async {
                            try {
                              await donor.toggleBookmarkedStatus(
                                  auth.userId, auth.token);
                            } catch (error) {
                              print(error);
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: new Image.asset(
                            donor.donorGender == 'Female'
                                ? 'assets/icons/female.jpg'
                                : 'assets/icons/male.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          donor.isAnonymous ? 'Anonymous' : donor.donorName,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(donor.donorAddress,
                                style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cake_sharp, color: Colors.blueAccent),
                            SizedBox(width: 5),
                            Text(
                              donor.isAnonymous
                                  ? 'xx'
                                  : donor.donorAge.toString(),
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (donor.approveStatus == 'Approved')
                              Icon(
                                Icons.check_circle_outline_sharp,
                                color: Colors.green,
                              ),
                            if (donor.approveStatus == 'Pending')
                              Icon(
                                Icons.warning_amber_sharp,
                                color: Colors.orange[200],
                              ),
                            if (donor.approveStatus == 'Rejected')
                              Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            SizedBox(width: 5),
                            Text(donor.approveStatus,
                                style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.blueAccent),
                            SizedBox(width: 5),
                            Text(
                              '+1 ${donor.donorContactNumber}',
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
