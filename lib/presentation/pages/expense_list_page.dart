import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/expense/expense_bloc.dart';
import '../blocs/expense/expense_event.dart';
import '../blocs/expense/expense_state.dart';
import '../blocs/category/category_cubit.dart';
import '../blocs/category/category_state.dart';
import '../widgets/expense_card.dart';
import '../../domain/entities/category.dart';
import '../../injection_container.dart';
import 'add_expense_page.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<ExpenseBloc>()..add(LoadExpenses()),
        ),
        BlocProvider(
          create: (_) => sl<CategoryCubit>()..loadCategories(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expenses'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Implement filter dialog
              },
            ),
          ],
        ),
        body: BlocConsumer<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ExpenseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, expenseState) {
            if (expenseState is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (expenseState is ExpenseError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${expenseState.message}'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ExpenseBloc>().add(LoadExpenses());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (expenseState is ExpenseLoaded) {
              if (expenseState.expenses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No expenses yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to add your first expense',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, categoryState) {
                  final categories = categoryState is CategoryLoaded
                      ? categoryState.categories
                      : [];

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ExpenseBloc>().add(LoadExpenses());
                    },
                    child: ListView.builder(
                      itemCount: expenseState.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenseState.expenses[index];
                        Category? category;
                        try {
                          category = categories.firstWhere(
                            (c) => c.id == expense.categoryId,
                          );
                        } catch (e) {
                          category = null;
                        }

                        return ExpenseCard(
                          expense: expense,
                          category: category,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddExpensePage(expense: expense),
                              ),
                            );
                          },
                          onDelete: () {
                            _showDeleteConfirmation(context, expense.id);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddExpensePage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ExpenseBloc>().add(DeleteExpense(id));
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
