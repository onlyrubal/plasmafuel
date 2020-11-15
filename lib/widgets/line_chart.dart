import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineReportChart extends StatelessWidget {
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
    return [
      FlSpot(0, 38310),
      FlSpot(1, 46253),
      FlSpot(2, 50210),
      FlSpot(3, 47638),
      FlSpot(4, 50356),
      FlSpot(5, 45674),
      FlSpot(6, 45903),
    ];
  }
}
