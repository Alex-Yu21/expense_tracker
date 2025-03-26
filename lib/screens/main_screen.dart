import 'package:expense_tracker/screens/expenses/expenses_screen.dart';
import 'package:expense_tracker/screens/new_expense.dart';
import 'package:expense_tracker/screens/stats/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const NewExpense(),
    );
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ExpensesScreen(),
      const StatsScreen(),
    ];

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(""),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlatformText(
                  'Welcome!',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                ),
                PlatformText('John Doe'),
              ],
            ),
          ],
        ),
        trailingActions: [
          PlatformIconButton(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            materialIcon: const Icon(Icons.add),
            cupertinoIcon: const Icon(CupertinoIcons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
      ),
      bottomNavBar: PlatformNavBar(
        height: 45,
        currentIndex: _selectedTabIndex,
        itemChanged: _onTabChanged,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 25)),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart, size: 25)),
        ],
      ),
      body: pages[_selectedTabIndex],
    );
  }
}
