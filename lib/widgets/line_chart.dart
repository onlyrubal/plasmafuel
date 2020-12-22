import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineReportChart extends StatelessWidget {
  final List<FlSpot> weeklyCasesCount;
  LineReportChart({this.weeklyCasesCount});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: getSpots(),
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              colors: [Theme.of(context).primaryColor],
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> getSpots() {
    return weeklyCasesCount;
  }
}
