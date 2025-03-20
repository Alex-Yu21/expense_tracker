import 'package:expense_tracker/screens/expenses/expense_list/expenses_list.dart';
import 'package:expense_tracker/screens/expenses/total_balance_card.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpensesScreen extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense) onRemoveExpense;

  const ExpensesScreen({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = Center(
      child: PlatformText('No expense found. Start adding some!'),
    );

    if (expenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: expenses,
        onRemoveExpense: onRemoveExpense,
      );
    }

    return width < 600
        ? Column(
            children: [
              const TotalBalanceCard(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlatformText(
                      'Transactions:',
                      style: PlatformTextThemes.titleStyle.copyWith(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: PlatformText(
                        'View All',
                        style: PlatformTextThemes.titleStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: mainContent),
            ],
          )
        : Row(
            children: [
              const Expanded(flex: 2, child: TotalBalanceCard()),
              Expanded(flex: 4, child: mainContent),
            ],
          );
  }
}
