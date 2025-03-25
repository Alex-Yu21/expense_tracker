import 'package:expense_tracker/data/registered_expenses';
import 'package:expense_tracker/screens/stats/chart.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('d MMMM yyyy').format(now);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlatformText(
              'Transactions',
              style: PlatformTextThemes.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kColorScheme.secondaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Chart(expenses: registeredExpenses),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formattedDate, style: PlatformTextThemes.titleStyle),
                  Text('data', style: PlatformTextThemes.titleStyle),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 40,
                            color: kColorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
                          PlatformText(
                            "category.title",
                            style: PlatformTextThemes.titleStyle,
                          ),
                          Spacer(),
                          PlatformText("-\$",
                              style: PlatformTextThemes.titleStyle),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
