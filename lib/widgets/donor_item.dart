import 'dart:ui';
import 'package:flutter/material.dart';
import '../providers/donor_info.dart';

class DonorItem extends StatelessWidget {
  Donor donor;
  DonorItem(this.donor);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
          color: donor.approveStatus == 'Approved'
              ? Colors.green[50]
              : (donor.approveStatus == 'Pending'
                  ? Colors.yellow[50]
                  : Colors.red[50]),
          margin: EdgeInsets.all(30),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 150,
                  width: 150,
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
                Container(
                  height: 255,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        donor.donorName,
                      ),
                      SizedBox(height: 10),
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
                            donor.donorAge.toString(),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
