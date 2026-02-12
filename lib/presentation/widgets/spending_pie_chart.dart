import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/category.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<Category, double> categorySpending;

  const SpendingPieChart({
    super.key,
    required this.categorySpending,
  });

  @override
  Widget build(BuildContext context) {
    if (categorySpending.isEmpty) {
      return const Center(
        child: Text('No spending data available'),
      );
    }

    return PieChart(
      PieChartData(
        sections: _buildSections(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = categorySpending.values.fold<double>(0, (sum, val) => sum + val);
    
    return categorySpending.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      return PieChartSectionData(
        color: Color(entry.key.color),
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
