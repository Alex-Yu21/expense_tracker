import 'package:expense_tracker/screens/chart/chart.dart';
import 'package:expense_tracker/screens/home_screen/expense_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/home_screen/new_expense.dart';
import 'package:expense_tracker/screens/home_screen/total_balance_card.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'FlutterCourse',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: PlatformText('Expense deleted.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = Center(
      child: PlatformText('No expense found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(""),
              radius: 16,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlatformText(
                  'Welcome!',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
                PlatformText(
                  'John Doe',
                ),
              ],
            ),
          ],
        ),
        trailingActions: [
          PlatformIconButton(
            padding: EdgeInsets.symmetric(horizontal: 15),
            materialIcon: const Icon(Icons.add),
            cupertinoIcon: const Icon(CupertinoIcons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
      ),
      bottomNavBar: PlatformNavBar(
        height: 45,
        items: [
          BottomNavigationBarItem(
              icon: Icon(PlatformIcons(context).home, size: 25)),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart, size: 25)),
          BottomNavigationBarItem(
              icon: Icon(PlatformIcons(context).person, size: 25)),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                TotalBalanceCard(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                              fontSize: 14, fontWeight: FontWeight.w400),
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
                Expanded(flex: 2, child: TotalBalanceCard()),
                Expanded(flex: 4, child: mainContent),
              ],
            ),
    );
  }
}
