class AppConstants {
  static const String appName = 'Expense Tracker';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'expense_tracker.db';
  static const int databaseVersion = 1;
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'UPI',
    'Bank Transfer',
    'Other',
  ];
  
  // Default Categories
  static const Map<String, Map<String, dynamic>> defaultCategories = {
    'food_dining': {
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': 0xFFFF6B6B,
    },
    'transport': {
      'name': 'Transport',
      'icon': 'directions_car',
      'color': 0xFF4ECDC4,
    },
    'entertainment': {
      'name': 'Entertainment',
      'icon': 'movie',
      'color': 0xFFFFE66D,
    },
    'bills_utilities': {
      'name': 'Bills & Utilities',
      'icon': 'receipt',
      'color': 0xFF95E1D3,
    },
    'shopping': {
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'color': 0xFFFFA07A,
    },
    'health_fitness': {
      'name': 'Health & Fitness',
      'icon': 'fitness_center',
      'color': 0xFF98D8C8,
    },
    'education': {
      'name': 'Education',
      'icon': 'school',
      'color': 0xFF6C5CE7,
    },
    'travel': {
      'name': 'Travel',
      'icon': 'flight',
      'color': 0xFF74B9FF,
    },
    'groceries': {
      'name': 'Groceries',
      'icon': 'local_grocery_store',
      'color': 0xFFA29BFE,
    },
    'other': {
      'name': 'Other',
      'icon': 'more_horiz',
      'color': 0xFFDFE6E9,
    },
  };
  
  // Budget Warning Threshold
  static const double budgetWarningThreshold = 0.8; // 80%
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String monthYearFormat = 'MMMM yyyy';
  
  // Export
  static const String csvExportFileName = 'expense_tracker_export.csv';
}
