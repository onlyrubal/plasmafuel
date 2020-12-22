import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/line_chart.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final int effectedNum;
  final Color iconColor;
  final Function press;
  final List<FlSpot> weeklyCasesCount;

  const InfoCard(
      {Key key,
      this.title,
      this.effectedNum,
      this.iconColor,
      this.press,
      this.weeklyCasesCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: press,
          child: Container(
            width: constraints.maxWidth / 2 - 10,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        // wrapped within an expanded widget to allow for small density device
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/running.svg",
                              height: 20,
                              width: 20,
                              color: iconColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "$effectedNum \n",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                TextSpan(
                                  text: "People",
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (weeklyCasesCount.isNotEmpty)
                            ? Expanded(
                                child: LineReportChart(
                                    weeklyCasesCount: weeklyCasesCount),
                              )
                            : Text(''),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
