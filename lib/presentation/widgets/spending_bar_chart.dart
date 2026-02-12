import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingBarChart extends StatelessWidget {
  final Map<DateTime, double> dailySpending;

  const SpendingBarChart({
    super.key,
    required this.dailySpending,
  });

  @override
  Widget build(BuildContext context) {
    if (dailySpending.isEmpty) {
      return const Center(
        child: Text('No spending data available'),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dailySpending.keys.length) {
                  final date = dailySpending.keys.elementAt(index);
                  return Text('${date.day}', style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(),
      ),
    );
  }

  double _getMaxY() {
    final max = dailySpending.values.fold<double>(0, (max, val) => val > max ? val : max);
    return max * 1.2; // Add 20% padding
  }

  List<BarChartGroupData> _buildBarGroups() {
    return dailySpending.entries.toList().asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value,
            color: Colors.blue,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }
}
