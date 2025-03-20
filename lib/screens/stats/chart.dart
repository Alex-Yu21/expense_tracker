import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(mainBarData());
  }

   BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 10,
          gradient: LinearGradient(
          colors: [
            Theme.of(context)
                .colorScheme
                .primary
                .withAlpha((1 * 255).round()),
            Theme.of(context)
                .colorScheme
                .primary
                .withAlpha((0.7 * 255).round())
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 6, 
            color: Colors.white54,
          ),
        ),
      ],
    );
  }


  List<BarChartGroupData> showingGroups() {
    final List<num> values = [2, 3, 2, 4.5, 3.8, 1.5, 4, 3.8];

    return List.generate(values.length, (i) {
      return makeGroupData(i, values[i].toDouble());
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitles,
            reservedSize: 40,
            interval: 1,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: getTitles,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: showingGroups(),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = PlatformTextThemes.titleStyle;
    final labels = ['01', '02', '03', '04', '05', '06', '07', '08'];

    if (value.toInt() >= 0 && value.toInt() < labels.length) {
      return SideTitleWidget(
        meta: meta,
        space: 16,
        child: Text(labels[value.toInt()], style: style),
      );
    }
    return Container();
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = PlatformTextThemes.titleStyle;
    final labels = {1: '1K', 2: '2K', 3: '3K', 4: '4K', 5: '5K'};

    if (labels.containsKey(value.toInt())) {
      return SideTitleWidget(
        meta: meta,
        space: 1,
        child: Text(labels[value.toInt()]!, style: style),
      );
    }
    return Container();
  }
}
