import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

final uuid = const Uuid();

enum Category {
  food,
  leisure,
  traffic,
  work,
  bills,
  medical,
  investments,
  gifts
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.movie,
  Category.traffic: Icons.directions_car,
  Category.work: Icons.work,
  Category.bills: Icons.receipt_long,
  Category.medical: Icons.local_hospital,
  Category.investments: Icons.trending_up,
  Category.gifts: Icons.card_giftcard,
};

class Expense {
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map, String id) {
    return Expense(
      id: id,
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: Category.values.firstWhere((c) => c.name == map['category']),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(
    List<Expense> allExpenses,
    this.category,
  ) : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
