import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat.yMMMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _submitExpenseData() {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, and date are entered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    final enteredAmount = double.parse(_amountController.text);

    widget.onAddExpense(
      Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: TitleTextFormField(
                                controller: _titleController)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: AmountTextFormField(
                                controller: _amountController)),
                      ],
                    )
                  else
                    TitleTextFormField(controller: _titleController),
                  const SizedBox(height: 10),
                  if (width >= 600)
                    Row(
                      children: [
                        CategoryDropdown(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (category) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DatePicker(
                                selectedDate: _selectedDate,
                                onDateSelected: (pickedDate) {
                                  setState(() {
                                    _selectedDate = pickedDate;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                            child: AmountTextFormField(
                                controller: _amountController)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DatePicker(
                                selectedDate: _selectedDate,
                                onDateSelected: (pickedDate) {
                                  setState(() {
                                    _selectedDate = pickedDate;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      children: [
                        Spacer(),
                        cancelButton(context),
                        saveButton(),
                      ],
                    )
                  else
                    Row(
                      children: [
                        CategoryDropdown(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (category) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                        const Spacer(),
                        cancelButton(context),
                        saveButton(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      onPressed: _submitExpenseData,
      child: const Text('Save Expense'),
    );
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    );
  }
}

class DatePicker extends StatelessWidget {
  const DatePicker(
      {super.key, required this.onDateSelected, required this.selectedDate});

  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  Future<void> _presentDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(selectedDate == null
            ? 'No date selected'
            : formatter.format(selectedDate!)),
        IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () => _presentDatePicker(context),
        ),
      ],
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final Category selectedCategory;
  final Function(Category) onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Category>(
        value: selectedCategory,
        items: Category.values
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name.toUpperCase()),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onCategoryChanged(value);
          }
        });
  }
}

class AmountTextFormField extends StatelessWidget {
  const AmountTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixText: '\$',
        labelText: 'Amount',
      ),
      validator: (value) {
        final parsedValue = double.tryParse(value ?? '');
        if (parsedValue == null || parsedValue <= 0) {
          return 'Invalid amount';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+([.,]?\d{0,2})?')),
      ],
    );
  }
}

class TitleTextFormField extends StatelessWidget {
  const TitleTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 50,
      decoration: const InputDecoration(labelText: 'Title'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a valid title';
        }
        return null;
      },
    );
  }
}
