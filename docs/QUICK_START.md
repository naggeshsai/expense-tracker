# Quick Start Guide

## 🚀 Get Up and Running in 5 Minutes

### Prerequisites
- Flutter SDK 3.0+ installed
- Your preferred IDE (VS Code or Android Studio)

### Installation Steps

```bash
# 1. Clone the repository
git clone https://github.com/naggeshsai/expense-tracker.git
cd expense-tracker

# 2. Install dependencies
flutter pub get

# 3. Generate database code
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Generate platform support files (required after cloning)
flutter create . --platforms android,web,windows

# 5. Run the app
flutter run
```

That's it! The app should now be running on your device/emulator.

### First Use

1. **The app will automatically create 10 default categories on first launch**
2. **Add your first expense:**
   - Tap the floating **+** button
   - Enter amount and select category
   - Tap "Add Expense"

3. **Track debts (paid for someone else):**
   - While adding an expense, toggle **"Paid for someone else"**
   - Enter the person's name
   - View all debts in the **Debts** tab

4. **View your dashboard:**
   - See spending breakdown by category
   - View charts and analytics
   - Filter by date range

5. **Set a budget:**
   - Go to Budget tab
   - Tap **+** to add a budget
   - Monitor your spending

### Common Commands

```bash
# Run on specific device
flutter devices                    # List devices
flutter run -d <device-id>         # Run on specific device

# Development
flutter run --debug                # Debug mode
flutter run --profile              # Profile mode
flutter run --release              # Release mode

# Code generation (if you make database changes)
flutter pub run build_runner watch # Auto-generate on changes

# Testing
flutter test                       # Run all tests
flutter test test/blocs/           # Run specific test folder

# Code quality
flutter analyze                    # Analyze code
flutter format .                   # Format code
```

### Troubleshooting

**Issue: Build fails with "no such file database.g.dart"**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue: App crashes on startup**
- Check logs: `flutter logs`
- Ensure all dependencies are installed
- Try on a different device/emulator

**Issue: Hot reload not working**
- Press `R` (capital R) for hot restart
- Or stop and run again

### Platform-Specific Commands

**Android:**
```bash
flutter run                        # Runs on connected Android device
```

**iOS (macOS only):**
```bash
open -a Simulator                  # Open iOS simulator
flutter run                        # Runs on iOS
```

**Web:**
```bash
flutter run -d chrome              # Runs in Chrome browser
```

**Windows:**
```bash
flutter run -d windows             # Runs as Windows app
```

### Next Steps

- � Use the [Debts tab](USER_GUIDE.md#debt-tracking) to track who owes you
- �📖 Read the [User Guide](USER_GUIDE.md) to learn all features
- 🏗️ Check [Architecture Documentation](ARCHITECTURE.md) to understand the code
- 🛠️ See [Setup Guide](SETUP.md) for detailed platform setup
- 🤝 Read [Contributing Guide](../CONTRIBUTING.md) to contribute

### Need Help?

- Check [docs/SETUP.md](SETUP.md) for detailed setup instructions
- Open an issue on GitHub
- Read the FAQ in [User Guide](USER_GUIDE.md)

Happy expense tracking! 💰📊
