import 'package:expense_tracker/services/expense_firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseFirestoreService firestoreService;

  ExpenseBloc({required this.firestoreService}) : super(ExpensesInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<RemoveExpense>(_onRemoveExpense);
  }

  Future<void> _onLoadExpenses(
      LoadExpenses event, Emitter<ExpenseState> emit) async {
    try {
      final expenses = await firestoreService.fetchExpenses();
      emit(ExpensesLoaded(expenses));
    } catch (e) {
      emit(ExpensesError('Failed to load expenses.'));
    }
  }

  Future<void> _onAddExpense(
      AddExpense event, Emitter<ExpenseState> emit) async {
    try {
      await firestoreService.addExpense(event.expense);
      add(LoadExpenses());
    } catch (e) {
      emit(ExpensesError('Failed to add expense.'));
    }
  }

  Future<void> _onRemoveExpense(
      RemoveExpense event, Emitter<ExpenseState> emit) async {
    try {
      await firestoreService.deleteExpense(event.expense.id);
      add(LoadExpenses());
    } catch (e) {
      emit(ExpensesError('Failed to delete expense.'));
    }
  }
}
