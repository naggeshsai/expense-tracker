# Documentation Index

Welcome to the Expense Tracker documentation! This index will help you find the right documentation for your needs.

## 📚 Documentation Structure

### For Users

- **[Quick Start Guide](QUICK_START.md)** - Get up and running in 5 minutes
- **[User Guide](USER_GUIDE.md)** - Complete guide to using all features
- **[Setup Guide](SETUP.md)** - Detailed platform-specific setup instructions

### For Developers

- **[Architecture Documentation](ARCHITECTURE.md)** - System design and architecture
- **[Architecture Diagrams](diagrams/ARCHITECTURE_DIAGRAMS.md)** - Visual diagrams and flow charts
- **[Project Summary](PROJECT_SUMMARY.md)** - Implementation status and known limitations

### For Contributors

- **[Contributing Guide](../CONTRIBUTING.md)** - How to contribute to the project
- **[License](../LICENSE)** - MIT License

## 🎯 Quick Navigation

### I want to...

**...run the app**
→ Go to [Quick Start Guide](QUICK_START.md)

**...understand the architecture**
→ Go to [Architecture Documentation](ARCHITECTURE.md)

**...set up for a specific platform (Android, iOS, Web, Windows)**
→ Go to [Setup Guide](SETUP.md)

**...learn all features**
→ Go to [User Guide](USER_GUIDE.md)

**...contribute code**
→ Go to [Contributing Guide](../CONTRIBUTING.md)

**...understand the implementation status**
→ Go to [Project Summary](PROJECT_SUMMARY.md)

**...see visual diagrams**
→ Go to [Architecture Diagrams](diagrams/ARCHITECTURE_DIAGRAMS.md)

## 📖 Reading Order for New Developers

1. **[Quick Start](QUICK_START.md)** - Get the app running first
2. **[Architecture](ARCHITECTURE.md)** - Understand the system design
3. **[Architecture Diagrams](diagrams/ARCHITECTURE_DIAGRAMS.md)** - Visualize the structure
4. **[Project Summary](PROJECT_SUMMARY.md)** - Know what's complete and what's not
5. **[User Guide](USER_GUIDE.md)** - Understand all features
6. **[Contributing](../CONTRIBUTING.md)** - Start contributing

## 🏗️ Architecture Overview

```
expense-tracker/
├── lib/
│   ├── core/              # Shared utilities, theme, constants
│   ├── data/              # Data layer (database, DAOs, repositories)
│   ├── domain/            # Business logic (entities, use cases)
│   ├── presentation/      # UI layer (pages, widgets, BLoCs)
│   ├── app.dart          # App root
│   └── main.dart         # Entry point
├── test/                  # Unit and widget tests
└── docs/                 # Documentation (you are here!)
```

## 🔑 Key Concepts

### Clean Architecture
The app follows Clean Architecture with three layers:
- **Presentation**: UI and state management
- **Domain**: Business logic and entities
- **Data**: Database and data sources

### State Management
- **BLoC**: For complex state (Expenses)
- **Cubit**: For simpler state (Categories, Budget, Settings)

### Database
- **Drift**: Type-safe SQLite wrapper
- **Local-first**: All data stored locally
- **Ready for sync**: UUID keys, isSynced field

## 📱 Platforms Supported

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: flutter_bloc
- **Database**: Drift (SQLite)
- **DI**: GetIt
- **Charts**: fl_chart
- **UI**: Material Design 3

## 📞 Support

- Check the docs
- Open an issue on GitHub
- Read the FAQ in [User Guide](USER_GUIDE.md)

## 🎓 Learning Resources

### Flutter
- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Guide](https://resocoder.com/flutter-clean-architecture-tdd/)

### State Management
- [BLoC Pattern](https://bloclibrary.dev)
- [BLoC vs Cubit](https://bloclibrary.dev/#/coreconcepts?id=cubit-vs-bloc)

### Database
- [Drift Documentation](https://drift.simonbinder.eu/)

## 🗺️ Project Roadmap

### Phase 1 (Current) - Local Storage ✅
- ✅ Core architecture
- ✅ CRUD operations
- ✅ Local database
- ✅ Basic analytics
- ⚠️ Some UI features incomplete

### Phase 2 (Future) - Cloud Sync
- ⏳ Cloud synchronization
- ⏳ Multi-device support
- ⏳ Backup and restore
- ⏳ Conflict resolution

### Phase 3 (Future) - Advanced Features
- ⏳ Receipt attachments
- ⏳ Income tracking
- ⏳ Advanced reports
- ⏳ Shared budgets
- ⏳ AI-powered insights

## 📊 Documentation Stats

- Total Documents: 8
- Total Diagrams: 10+
- Total Words: ~25,000
- Coverage: Complete

## 🤝 Contributing to Docs

Found a typo or want to improve documentation?
1. Fork the repository
2. Edit the relevant doc file
3. Submit a pull request

All contributions welcome!

---

**Happy Reading! 📚**
