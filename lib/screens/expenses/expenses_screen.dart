import 'package:expense_tracker/blocs/expense_bloc.dart';
import 'package:expense_tracker/blocs/expense_event.dart';
import 'package:expense_tracker/blocs/expense_state.dart';
import 'package:expense_tracker/screens/expenses/expense_list/expenses_list.dart';
import 'package:expense_tracker/screens/expenses/total_balance_card.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is! ExpensesLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final expenses = state.expenses;

        Widget mainContent = Center(
          child: PlatformText('No expense found. Start adding some!'),
        );

        if (expenses.isNotEmpty) {
          mainContent = ExpensesList(
            expenses: expenses,
            onRemoveExpense: (expense) {
              context.read<ExpenseBloc>().add(RemoveExpense(expense));
            },
          );
        }

        return width < 600
            ? Column(
                children: [
                  const TotalBalanceCard(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PlatformText(
                          'Transactions:',
                          style: PlatformTextThemes.titleStyle.copyWith(
                            fontSize: 14,
                          ),
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
      },
    );
  }
}
