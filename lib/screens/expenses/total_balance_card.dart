import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context)
                .colorScheme
                .primary
                .withAlpha((0.6 * 255).round()),
            Theme.of(context)
                .colorScheme
                .primary
                .withAlpha((0.0 * 255).round())
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurStyle: BlurStyle.outer,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlatformText(
            'Total balance:',
            style: PlatformTextThemes.titleStyle,
          ),
          const SizedBox(
            height: 12,
          ),
          PlatformText(
            '\$ 4000.00',
            style:  PlatformTextThemes.titleStyle
                .copyWith(fontSize: 35),
          ),
         const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Colors.white30,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          context.platformIcons.upArrow,
                          size: 15,
                          color: Colors.green,
                        ),
                      ),
                    ),
                   const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlatformText(
                          'Income',
                          style: PlatformTextThemes.titleStyle
                              .copyWith(
                            fontSize: 14,
                          ),
                        ),
                        PlatformText(
                          '\$ 2500.00',
                          style: PlatformTextThemes.titleStyle
                              .copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Colors.white30,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          context.platformIcons.downArrow,
                          size: 15,
                          color: Colors.red,
                        ),
                      ),
                    ),
                   const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlatformText(
                          'Expenses',
                          style: PlatformTextThemes.titleStyle
                              .copyWith(
                            fontSize: 14,
                          ),
                        ),
                        PlatformText(
                          '\$ 2500.00',
                          style: PlatformTextThemes.titleStyle
                              .copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
