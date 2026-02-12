import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final double totalSpending;
  final Map<String, double> categorySpending;
  final bool isLoading;
  final String? error;

  const DashboardState({
    required this.startDate,
    required this.endDate,
    this.totalSpending = 0.0,
    this.categorySpending = const {},
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        totalSpending,
        categorySpending,
        isLoading,
        error,
      ];

  DashboardState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    double? totalSpending,
    Map<String, double>? categorySpending,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalSpending: totalSpending ?? this.totalSpending,
      categorySpending: categorySpending ?? this.categorySpending,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
