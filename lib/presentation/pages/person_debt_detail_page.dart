import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/debt/debt_cubit.dart';
import '../blocs/debt/debt_state.dart';
import '../blocs/settings/settings_cubit.dart';
import '../blocs/settings/settings_state.dart';
import '../blocs/category/category_cubit.dart';
import '../blocs/category/category_state.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/category.dart';
import '../../injection_container.dart';

class PersonDebtDetailPage extends StatelessWidget {
  final String personName;

  const PersonDebtDetailPage({
    super.key,
    required this.personName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<DebtCubit>()..loadExpensesForPerson(personName),
        ),
        BlocProvider(
          create: (_) => sl<CategoryCubit>()..loadCategories(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(personName),
        ),
        body: BlocBuilder<DebtCubit, DebtState>(
          builder: (context, state) {
            if (state is DebtLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DebtError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is DebtPersonExpensesLoaded) {
              return BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  final symbol = settingsState.currencySymbol;

                  return BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, categoryState) {
                      final categories = categoryState is CategoryLoaded
                          ? categoryState.categories
                          : <Category>[];

                      return Column(
                        children: [
                          // Total owed header
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .errorContainer
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$personName owes you',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  CurrencyFormatter.format(
                                    state.totalOwed,
                                    symbol: symbol,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[700],
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state.expenses.length} ${state.expenses.length == 1 ? 'expense' : 'expenses'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Expense list
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.expenses.length,
                              itemBuilder: (context, index) {
                                final expense = state.expenses[index];
                                Category? category;
                                try {
                                  category = categories.firstWhere(
                                    (c) => c.id == expense.categoryId,
                                  );
                                } catch (e) {
                                  category = null;
                                }

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: category != null
                                            ? Color(category.color)
                                                .withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        _getIconData(
                                            category?.icon ?? 'more_horiz'),
                                        color: category != null
                                            ? Color(category.color)
                                            : Colors.grey,
                                      ),
                                    ),
                                    title: Text(
                                        category?.name ?? 'Unknown Category'),
                                    subtitle: Text(
                                      DateFormat('MMM dd, yyyy')
                                          .format(expense.date),
                                    ),
                                    trailing: Text(
                                      CurrencyFormatter.format(
                                        expense.amount,
                                        symbol: symbol,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
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
