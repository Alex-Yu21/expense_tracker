import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import '../../models/expense.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpensesInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<RemoveExpense>(_onRemoveExpense);
  }

  void _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) {
    emit(ExpensesLoaded([]));
  }

  void _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) {
    if (state is ExpensesLoaded) {
      final updatedExpenses =
          List<Expense>.from((state as ExpensesLoaded).expenses)
            ..add(event.expense);
      emit(ExpensesLoaded(updatedExpenses));
    }
  }

  void _onRemoveExpense(RemoveExpense event, Emitter<ExpenseState> emit) {
    if (state is ExpensesLoaded) {
      final updatedExpenses = (state as ExpensesLoaded)
          .expenses
          .where((e) => e.id != event.expense.id)
          .toList();
      emit(ExpensesLoaded(updatedExpenses));
    }
  }
}
