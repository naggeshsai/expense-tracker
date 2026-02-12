# Expense Tracker

A complete cross-platform expense tracking application built with Flutter that runs on **Android, iOS, Web, and Windows**.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Features

### Expense Management
- ✅ Add, edit, and delete expenses
- ✅ Multiple payment methods (Cash, Credit Card, Debit Card, UPI, Bank Transfer, Other)
- ✅ Mark expenses as recurring
- ✅ Filter expenses by date range and category
- ✅ Rich note-taking for each expense

### Category Management
- ✅ 10 pre-defined categories with icons and colors
- ✅ Custom category support
- ✅ Edit and delete custom categories
- ✅ Visual category representation

### Dashboard & Analytics
- ✅ Monthly total spending summary
- ✅ Pie chart showing category-wise breakdown
- ✅ Bar chart for daily spending
- ✅ Line chart for 6-month spending trend
- ✅ Quick stats: today's spend, weekly spend, average daily spend
- ✅ Date range filtering

### Budget Tracking
- ✅ Set monthly budgets (overall and per-category)
- ✅ Visual progress bars with color-coded indicators
- ✅ Warning indicators at 80% budget usage
- ✅ Over-budget alerts

### Settings & Customization
- ✅ Dark/Light theme toggle
- ✅ Currency selection (USD, EUR, GBP, INR, JPY)
- ✅ Export data to CSV
- ✅ Clear all data option with confirmation

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three distinct layers:

```
├── Presentation Layer (UI, BLoC/Cubit)
├── Domain Layer (Entities, Use Cases, Repository Interfaces)
└── Data Layer (Repository Implementations, DAOs, Database)
```

### Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: flutter_bloc (BLoC/Cubit pattern)
- **Local Database**: Drift (type-safe SQLite wrapper)
- **Charts**: fl_chart
- **Dependency Injection**: get_it
- **UI**: Material Design 3 with dark mode

For detailed architecture documentation, see [ARCHITECTURE.md](docs/ARCHITECTURE.md).

## 📦 Project Structure

```
lib/
├── main.dart
├── app.dart
├── injection_container.dart
├── core/
│   ├── theme/
│   ├── constants/
│   └── utils/
├── data/
│   ├── models/
│   ├── local/
│   │   ├── database.dart
│   │   ├── tables/
│   │   └── daos/
│   ├── remote/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── blocs/
    ├── pages/
    └── widgets/
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/naggeshsai/expense-tracker.git
cd expense-tracker
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code for Drift database**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
# For Android/iOS
flutter run

# For Web
flutter run -d chrome

# For Windows
flutter run -d windows
```

## 🧪 Testing

Run unit tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## 📊 Database Schema

### Expenses Table
- `id` (TEXT, PRIMARY KEY) - UUID
- `amount` (REAL) - Expense amount
- `category_id` (TEXT) - Foreign key to categories
- `note` (TEXT, NULLABLE) - Optional note
- `date` (DATETIME) - Transaction date
- `payment_method` (TEXT) - Payment method used
- `is_recurring` (BOOLEAN) - Recurring flag
- `created_at` (DATETIME) - Creation timestamp
- `updated_at` (DATETIME) - Update timestamp
- `is_synced` (BOOLEAN) - Sync status (for Phase 2)

### Categories Table
- `id` (TEXT, PRIMARY KEY) - UUID
- `name` (TEXT) - Category name
- `icon` (TEXT) - Material icon name
- `color` (INTEGER) - Color value
- `is_custom` (BOOLEAN) - Custom category flag
- `created_at` (DATETIME) - Creation timestamp

### Budgets Table
- `id` (TEXT, PRIMARY KEY) - UUID
- `category_id` (TEXT, NULLABLE) - Null for overall budget
- `amount` (REAL) - Budget amount
- `month` (INTEGER) - Month (1-12)
- `year` (INTEGER) - Year
- `created_at` (DATETIME) - Creation timestamp
- `updated_at` (DATETIME) - Update timestamp

## 🎨 Screenshots

> Screenshots will be added after the app is built and tested

## 🔜 Phase 2 - Cloud Sync (Future)

The architecture is designed to support cloud synchronization in the future:
- Abstract `SyncService` interface ready for implementation
- `isSynced` field in expense model
- Repository pattern allows easy swapping of data sources
- Can integrate with Supabase, Firebase, or custom backend

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Naggesh Sai**
- GitHub: [@naggeshsai](https://github.com/naggeshsai)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI/UX guidelines
- All open-source contributors

## 📚 Additional Documentation

- [Quick Start Guide](docs/QUICK_START.md) - Get started in 5 minutes
- [Architecture Documentation](docs/ARCHITECTURE.md) - Detailed architecture and design
- [Architecture Diagrams](docs/diagrams/ARCHITECTURE_DIAGRAMS.md) - Visual system diagrams
- [Setup Guide](docs/SETUP.md) - Platform-specific setup instructions  
- [User Guide](docs/USER_GUIDE.md) - Complete feature guide
- [Project Summary](docs/PROJECT_SUMMARY.md) - Implementation status
- [Implementation Notes](docs/IMPLEMENTATION_NOTES.md) - Technical details
- [Contributing Guide](CONTRIBUTING.md) - How to contribute
