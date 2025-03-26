import 'package:expense_tracker/blocs/expense_bloc.dart';
import 'package:expense_tracker/blocs/expense_state.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        double totalExpenses = 0.0;
        double income = 4000.0; // TODO dynamic incom

        if (state is ExpensesLoaded) {
          totalExpenses = state.expenses.fold(
            0.0,
            (sum, item) => sum + item.amount,
          );
        }

        final balance = income - totalExpenses;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
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
                    .withAlpha((0.0 * 255).round()),
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
              const SizedBox(height: 12),
              PlatformText(
                '\$ ${balance.toStringAsFixed(2)}',
                style: PlatformTextThemes.titleStyle.copyWith(fontSize: 35),
              ),
              const SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _AmountIndicator(
                      label: 'Income',
                      amount: income,
                      icon: context.platformIcons.upArrow,
                      iconColor: Colors.green,
                    ),
                    _AmountIndicator(
                      label: 'Expenses',
                      amount: totalExpenses,
                      icon: context.platformIcons.downArrow,
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _AmountIndicator extends StatelessWidget {
  const _AmountIndicator({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final double amount;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white30,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, size: 15, color: iconColor),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlatformText(
              label,
              style: PlatformTextThemes.titleStyle.copyWith(fontSize: 14),
            ),
            PlatformText(
              '\$ ${amount.toStringAsFixed(2)}',
              style: PlatformTextThemes.titleStyle.copyWith(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
