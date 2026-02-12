import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/date_utils.dart' as app_date;
import '../../../domain/usecases/expense_usecases.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetTotalSpendingUseCase getTotalSpendingUseCase;
  final GetCategorySpendingUseCase getCategorySpendingUseCase;

  DashboardCubit({
    required this.getTotalSpendingUseCase,
    required this.getCategorySpendingUseCase,
  }) : super(DashboardState(
          startDate: app_date.DateUtils.startOfMonth,
          endDate: app_date.DateUtils.endOfMonth,
        ));

  Future<void> loadDashboardData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final totalSpending = await getTotalSpendingUseCase(
        state.startDate,
        state.endDate,
      );
      final categorySpending = await getCategorySpendingUseCase(
        state.startDate,
        state.endDate,
      );
      emit(state.copyWith(
        totalSpending: totalSpending,
        categorySpending: categorySpending,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void setDateRange(DateTime start, DateTime end) {
    emit(state.copyWith(startDate: start, endDate: end));
    loadDashboardData();
  }
}
