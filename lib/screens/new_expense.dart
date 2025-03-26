import 'package:expense_tracker/blocs/expense_bloc.dart';
import 'package:expense_tracker/blocs/expense_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final DateFormat formatter = DateFormat.yMMMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

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
      showPlatformDialog(
        context: context,
        builder: (ctx) => PlatformAlertDialog(
          title: PlatformText('Invalid input'),
          content: PlatformText(
              'Please make sure a valid title, amount, and date are entered.'),
          actions: [
            PlatformDialogAction(
              onPressed: () => Navigator.pop(ctx),
              child: PlatformText('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    final enteredAmount = double.parse(_amountController.text);

    final newExpense = Expense(
      title: _titleController.text.trim(),
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    context.read<ExpenseBloc>().add(AddExpense(newExpense));

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
                            child: TitlePlatformTextFormField(
                                controller: _titleController)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: AmountPlatformTextFormField(
                                controller: _amountController)),
                      ],
                    )
                  else
                    TitlePlatformTextFormField(controller: _titleController),
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
                            child: AmountPlatformTextFormField(
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
                        const Spacer(),
                        cancelButton(context),
                        saveButton(context),
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
                        saveButton(context),
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

  PlatformElevatedButton saveButton(BuildContext context) {
    return PlatformElevatedButton(
      onPressed: _submitExpenseData,
      child: PlatformText('Save Expense'),
      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      cupertino: (_, __) => CupertinoElevatedButtonData(
        color: CupertinoTheme.of(context).primaryColor,
      ),
    );
  }

  PlatformTextButton cancelButton(BuildContext context) {
    return PlatformTextButton(
      onPressed: () => Navigator.pop(context),
      child: PlatformText('Cancel'),
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
    final pickedDate = await showPlatformDatePicker(
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
        PlatformText(selectedDate == null
            ? 'No date selected'
            : formatter.format(selectedDate!)),
        PlatformIconButton(
          materialIcon: const Icon(Icons.calendar_month),
          cupertinoIcon: const Icon(CupertinoIcons.calendar),
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
                  child: PlatformText(category.name.toUpperCase()),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onCategoryChanged(value);
          }
        });
  }
}

class AmountPlatformTextFormField extends StatelessWidget {
  const AmountPlatformTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformTextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      material: (_, __) => MaterialTextFormFieldData(
        decoration: const InputDecoration(
          prefixText: '\$',
          labelText: 'Amount',
        ),
      ),
      cupertino: (_, __) => CupertinoTextFormFieldData(
        prefix: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('\$', style: TextStyle(fontSize: 16)),
        ),
        placeholder: 'Amount',
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

class TitlePlatformTextFormField extends StatelessWidget {
  const TitlePlatformTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformTextFormField(
      controller: controller,
      maxLength: 50,
      material: (_, __) => MaterialTextFormFieldData(
        decoration: const InputDecoration(labelText: 'Title'),
      ),
      cupertino: (_, __) => CupertinoTextFormFieldData(
        placeholder: 'Title',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a valid title';
        }
        return null;
      },
    );
  }
}
