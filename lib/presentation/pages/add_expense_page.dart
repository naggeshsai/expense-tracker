import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../blocs/expense/expense_bloc.dart';
import '../blocs/expense/expense_event.dart';
import '../blocs/category/category_cubit.dart';
import '../blocs/category/category_state.dart';
import '../blocs/settings/settings_cubit.dart';
import '../blocs/settings/settings_state.dart';
import '../../domain/entities/expense.dart';
import '../../core/constants/app_constants.dart';
import '../../injection_container.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? expense;

  const AddExpensePage({super.key, this.expense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  String? _selectedCategoryId;
  String _selectedPaymentMethod = 'Cash';
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note ?? '';
      _selectedCategoryId = widget.expense!.categoryId;
      _selectedPaymentMethod = widget.expense!.paymentMethod;
      _selectedDate = widget.expense!.date;
      _isRecurring = widget.expense!.isRecurring;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ExpenseBloc>()),
        BlocProvider(create: (_) => sl<CategoryCubit>()..loadCategories()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, categoryState) {
            if (categoryState is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (categoryState is CategoryError) {
              return Center(child: Text('Error: ${categoryState.message}'));
            }

            if (categoryState is CategoryLoaded) {
              final categories = categoryState.categories;
              
              // Set default category if not set
              if (_selectedCategoryId == null && categories.isNotEmpty) {
                _selectedCategoryId = categories.first.id;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Amount Field
                      BlocBuilder<SettingsCubit, SettingsState>(
                        builder: (context, settingsState) {
                          return TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixText: '${settingsState.currencySymbol} ',
                              hintText: '0.00',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Row(
                              children: [
                                Icon(
                                  _getIconData(category.icon),
                                  color: Color(category.color),
                                ),
                                const SizedBox(width: 12),
                                Text(category.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Payment Method Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        decoration: const InputDecoration(
                          labelText: 'Payment Method',
                        ),
                        items: AppConstants.paymentMethods.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date Picker
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Date'),
                        subtitle: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Note Field
                      TextFormField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          labelText: 'Note (Optional)',
                          hintText: 'Add a note...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Recurring Checkbox
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Recurring Expense'),
                        value: _isRecurring,
                        onChanged: (value) {
                          setState(() {
                            _isRecurring = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      ElevatedButton(
                        onPressed: _saveExpense,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          widget.expense == null ? 'Add Expense' : 'Update Expense',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final note = _noteController.text.trim();
      final now = DateTime.now().toUtc();

      final expense = Expense(
        id: widget.expense?.id ?? const Uuid().v4(),
        amount: amount,
        categoryId: _selectedCategoryId!,
        note: note.isEmpty ? null : note,
        date: _selectedDate,
        paymentMethod: _selectedPaymentMethod,
        isRecurring: _isRecurring,
        createdAt: widget.expense?.createdAt ?? now,
        updatedAt: now,
        isSynced: false,
      );

      final bloc = sl<ExpenseBloc>();
      if (widget.expense == null) {
        bloc.add(AddExpense(expense));
      } else {
        bloc.add(UpdateExpense(expense));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.expense == null
                  ? 'Expense added successfully'
                  : 'Expense updated successfully',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'movie': Icons.movie,
      'receipt': Icons.receipt,
      'shopping_bag': Icons.shopping_bag,
      'fitness_center': Icons.fitness_center,
      'school': Icons.school,
      'flight': Icons.flight,
      'local_grocery_store': Icons.local_grocery_store,
      'more_horiz': Icons.more_horiz,
    };
    return iconMap[iconName] ?? Icons.more_horiz;
  }
}
