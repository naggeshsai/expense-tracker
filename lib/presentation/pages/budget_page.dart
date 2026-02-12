import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/budget/budget_cubit.dart';
import '../blocs/budget/budget_state.dart';
import '../blocs/category/category_cubit.dart';
import '../blocs/category/category_state.dart';
import '../blocs/dashboard/dashboard_cubit.dart';
import '../widgets/budget_progress_bar.dart';
import '../../injection_container.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BudgetCubit>()..loadBudgets()),
        BlocProvider(create: (_) => sl<CategoryCubit>()..loadCategories()),
        BlocProvider(create: (_) => sl<DashboardCubit>()..loadDashboardData()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Budgets'),
        ),
        body: BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, budgetState) {
            if (budgetState is BudgetLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (budgetState is BudgetError) {
              return Center(child: Text('Error: ${budgetState.message}'));
            }

            if (budgetState is BudgetLoaded) {
              if (budgetState.budgets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No budgets set',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to set your first budget',
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

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: budgetState.budgets.length,
                    itemBuilder: (context, index) {
                      final budget = budgetState.budgets[index];
                      dynamic category;
                      
                      if (budget.categoryId != null) {
                        try {
                          category = categories.firstWhere(
                            (c) => c.id == budget.categoryId,
                          );
                        } catch (e) {
                          category = null;
                        }
                      }

                      final categoryName = category?.name ?? 'Overall Budget';

                      // TODO: Get actual spending for this budget period
                      // For now, using mock data
                      final spent = budget.amount * 0.7;

                      return BudgetProgressBar(
                        spent: spent,
                        budget: budget.amount,
                        categoryName: categoryName,
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Implement add budget dialog
            _showAddBudgetDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Budget'),
        content: const Text('Budget creation coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
