import 'package:expense_tracker/blocs/expense_bloc.dart';
import 'package:expense_tracker/blocs/expense_state.dart';
import 'package:expense_tracker/screens/stats/chart.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';

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
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.9,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formattedDate, style: PlatformTextThemes.titleStyle),
                  const Text('Latest', style: PlatformTextThemes.titleStyle),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is! ExpensesLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final expenses = state.expenses;

                  if (expenses.isEmpty) {
                    return Center(
                      child: PlatformText('No transactions yet.'),
                    );
                  }

                  final latestExpenses = List<Expense>.from(expenses)
                    ..sort((a, b) => b.date.compareTo(a.date));

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: latestExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = latestExpenses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                categoryIcons[expense.category],
                                size: 40,
                                color: kColorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PlatformText(
                                      expense.title,
                                      style: PlatformTextThemes.titleStyle,
                                    ),
                                    PlatformText(
                                      DateFormat.yMMMd().format(expense.date),
                                      style: PlatformTextThemes.titleStyle
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                              PlatformText(
                                '-\$${expense.amount.toStringAsFixed(2)}',
                                style: PlatformTextThemes.titleStyle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
