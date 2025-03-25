import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Chart extends StatefulWidget {
  const Chart({required this.expenses, super.key});

  final List<Expense> expenses;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<double> calculateWeeklyExpenses() {
    final now = DateTime.now();
    final List<double> weeklySums = [];

    for (int i = 7; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: i * 7));
      final weekEnd = weekStart.add(const Duration(days: 7));

      final weekSum = widget.expenses
          .where((e) => e.date.isAfter(weekStart) && e.date.isBefore(weekEnd))
          .fold(0.0, (sum, e) => sum + e.amount);

      weeklySums.add(weekSum);
    }

    return weeklySums;
  }

  double findMaxY(List<double> values) {
    if (values.isEmpty) return 100;

    final max = values.reduce((a, b) => a > b ? a : b);

    if (max < 100) {
      return 100;
    } else if (max < 500) {
      return ((max / 100).ceil() * 100).toDouble();
    } else {
      return ((max / 1000).ceil() * 1000 + 100).toDouble();
    }
  }

  double get total {
    return widget.expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    final weeklyValues = calculateWeeklyExpenses();

    return Column(
      children: [
        const SizedBox(height: 8),
        PlatformText(
          "3 months",
          style: PlatformTextThemes.titleStyle
              .copyWith(fontWeight: FontWeight.w200),
        ),
        PlatformText(
          total.toStringAsFixed(0),
          style: PlatformTextThemes.titleStyle.copyWith(fontSize: 30),
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.6,
          child: BarChart(mainBarData(weeklyValues)),
        ),
      ],
    );
  }

  BarChartData mainBarData(List<double> values) {
    final maxY = findMaxY(values);

    return BarChartData(
      maxY: maxY,
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitles,
            reservedSize: 40,
            interval: (maxY / 5).roundToDouble(),
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
      barGroups: showingGroups(values),
    );
  }

  List<BarChartGroupData> showingGroups(List<double> values) {
    return List.generate(values.length, (i) {
      return makeGroupData(i, values[i]);
    });
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
              Theme.of(context).colorScheme.primary.withAlpha(255),
              Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha((0.7 * 255).round()),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: findMaxY(calculateWeeklyExpenses()),
            color: Colors.white54,
          ),
        ),
      ],
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

  String getFormattedYLabel(double value) {
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return '\$${value.toStringAsFixed(0)}';
    }
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = PlatformTextThemes.titleStyle;
    return SideTitleWidget(
      meta: meta,
      space: 1,
      child: Text(getFormattedYLabel(value), style: style),
    );
  }
}
