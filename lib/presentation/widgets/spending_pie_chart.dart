import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/category.dart';

class SpendingPieChart extends StatefulWidget {
  final Map<Category, double> categorySpending;

  const SpendingPieChart({
    super.key,
    required this.categorySpending,
  });

  @override
  State<SpendingPieChart> createState() => _SpendingPieChartState();
}

class _SpendingPieChartState extends State<SpendingPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categorySpending.isEmpty) {
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
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = widget.categorySpending.values.fold<double>(0, (sum, val) => sum + val);
    
    return widget.categorySpending.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value.key;
      final value = entry.value.value;
      final percentage = (value / total * 100);
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 65.0 : 50.0;
      final fontSize = isTouched ? 14.0 : 12.0;

      return PieChartSectionData(
        color: Color(category.color),
        value: value,
        title: isTouched
            ? '${category.name}\n${percentage.toStringAsFixed(1)}%'
            : '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
