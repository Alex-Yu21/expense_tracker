import '../../models/expense.dart';

abstract class ExpenseState {}

class ExpensesInitial extends ExpenseState {}

class ExpensesLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpensesLoaded(this.expenses);
}
