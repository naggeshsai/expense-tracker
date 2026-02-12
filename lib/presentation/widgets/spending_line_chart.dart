import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingLineChart extends StatelessWidget {
  final Map<DateTime, double> monthlySpending;

  const SpendingLineChart({
    super.key,
    required this.monthlySpending,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlySpending.isEmpty) {
      return const Center(
        child: Text('No spending data available'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < monthlySpending.keys.length) {
                  final date = monthlySpending.keys.elementAt(index);
                  return Text(
                    '${date.month}/${date.year.toString().substring(2)}',
                    style: const TextStyle(fontSize: 10),
                  );
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
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: _buildSpots(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    return monthlySpending.entries.toList().asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }
}
