import '../../models/expense.dart';

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  AddExpense(this.expense);
}

class RemoveExpense extends ExpenseEvent {
  final Expense expense;

  RemoveExpense(this.expense);
}
