import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  final double spent;
  final double budget;
  final String categoryName;

  const BudgetProgressBar({
    super.key,
    required this.spent,
    required this.budget,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final isWarning = percentage >= 0.8;
    final isOverBudget = percentage >= 1.0;

    Color getColor() {
      if (isOverBudget) return Colors.red;
      if (isWarning) return Colors.orange;
      return Colors.green;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '\$${spent.toStringAsFixed(2)} / \$${budget.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(getColor()),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(percentage * 100).toStringAsFixed(1)}% used',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: getColor(),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (isWarning && !isOverBudget)
              Text(
                'Warning: Approaching budget limit',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
              ),
            if (isOverBudget)
              Text(
                'Over budget!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
