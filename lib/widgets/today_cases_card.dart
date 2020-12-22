import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/line_chart.dart';

class TodayCasesCard extends StatelessWidget {
  final String title;
  final int effectedNum;
  final Color iconColor;
  final Function press;
  final List<FlSpot> weeklyCasesCount;

  const TodayCasesCard(
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
            height: 125,
            width: constraints.maxWidth / 2 - 10,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // wrapped within an expanded widget to allow for small density device
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
                      SizedBox(width: 40),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "$effectedNum \n",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 20),
                              ),
                              TextSpan(
                                text: "People",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
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
        );
      },
    );
  }
}
