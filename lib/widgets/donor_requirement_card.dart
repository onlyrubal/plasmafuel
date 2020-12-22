import 'package:flutter/material.dart';

class DonorRequirementCard extends StatelessWidget {
  String imageValue;
  String heading;

  DonorRequirementCard({
    this.imageValue,
    this.heading,
  });
  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 10),
            Image.asset(
              imageValue,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                heading,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.w100),
              ),
            )
          ],
        ),
      ),
    );
  }
}
