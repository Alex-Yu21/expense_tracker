import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseFirestoreService {
  final _collection = FirebaseFirestore.instance.collection('expenses');

  Future<List<Expense>> fetchExpenses() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => Expense.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addExpense(Expense expense) async {
    await _collection.add(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _collection.doc(id).delete();
  }
}
