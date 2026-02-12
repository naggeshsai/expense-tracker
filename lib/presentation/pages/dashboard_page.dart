import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dashboard/dashboard_cubit.dart';
import '../blocs/dashboard/dashboard_state.dart';
import '../blocs/category/category_cubit.dart';
import '../blocs/category/category_state.dart';
import '../widgets/summary_card.dart';
import '../widgets/spending_pie_chart.dart';
import '../widgets/date_range_selector.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/category.dart';
import '../../injection_container.dart';
import 'add_expense_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<DashboardCubit>()..loadDashboardData(),
        ),
        BlocProvider(
          create: (_) => sl<CategoryCubit>()..loadCategories(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, dashboardState) {
            if (dashboardState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (dashboardState.error != null) {
              return Center(child: Text('Error: ${dashboardState.error}'));
            }

            return BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
                final categories = categoryState is CategoryLoaded
                    ? categoryState.categories
                    : [];

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<DashboardCubit>().loadDashboardData();
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Date Range Selector
                      DateRangeSelector(
                        startDate: dashboardState.startDate,
                        endDate: dashboardState.endDate,
                        onDateRangeChanged: (start, end) {
                          context.read<DashboardCubit>().setDateRange(start, end);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Total Spending Summary
                      SummaryCard(
                        title: 'Total Spending',
                        value: CurrencyFormatter.format(dashboardState.totalSpending),
                        icon: Icons.account_balance_wallet,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 24),

                      // Category Breakdown Title
                      Text(
                        'Spending by Category',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Pie Chart
                      if (dashboardState.categorySpending.isNotEmpty)
                        SizedBox(
                          height: 250,
                          child: SpendingPieChart(
                            categorySpending: _mapCategorySpending(
                              dashboardState.categorySpending,
                              categories,
                            ),
                          ),
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('No expenses for this period'),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Category List with Amounts
                      if (dashboardState.categorySpending.isNotEmpty)
                        ..._buildCategoryList(
                          dashboardState.categorySpending,
                          categories,
                          context,
                        ),
                    ],
                  ),
                );
              },
            );
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

  Map<Category, double> _mapCategorySpending(
    Map<String, double> spending,
    List<dynamic> categories,
  ) {
    final result = <Category, double>{};
    for (final entry in spending.entries) {
      Category? category;
      try {
        category = categories.firstWhere((c) => c.id == entry.key) as Category;
      } catch (e) {
        continue; // Skip if category not found
      }
      result[category] = entry.value;
    }
    return result;
  }

  List<Widget> _buildCategoryList(
    Map<String, double> spending,
    List<dynamic> categories,
    BuildContext context,
  ) {
    final sortedEntries = spending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((entry) {
      dynamic category;
      try {
        category = categories.firstWhere((c) => c.id == entry.key);
      } catch (e) {
        return const SizedBox.shrink(); // Skip if not found
      }

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(category.color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(category.icon),
              color: Color(category.color),
            ),
          ),
          title: Text(category.name),
          trailing: Text(
            CurrencyFormatter.format(entry.value),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );
    }).toList();
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
