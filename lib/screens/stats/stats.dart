import 'package:expense_tracker/screens/stats/chart.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              height: MediaQuery.of(context).size.width,
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
              child: const Chart(),
            ),
          ],
        ),
      ),
    );
  }
}
