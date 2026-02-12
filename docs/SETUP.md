# Setup and Installation Guide

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Flutter SDK Setup](#flutter-sdk-setup)
3. [Project Setup](#project-setup)
4. [Platform-Specific Setup](#platform-specific-setup)
5. [Running the Application](#running-the-application)
6. [Building for Production](#building-for-production)
7. [Troubleshooting](#troubleshooting)

## System Requirements

### Minimum Requirements
- **RAM**: 8GB (16GB recommended)
- **Disk Space**: 10GB free space
- **OS**: Windows 10+, macOS 10.14+, Linux (64-bit)

### Software Requirements
- Git
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)
- Visual Studio (for Windows development)

## Flutter SDK Setup

### Windows
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to desired location (e.g., `C:\src\flutter`)
3. Add Flutter to PATH:
   - Search for "Environment Variables"
   - Edit PATH and add `C:\src\flutter\bin`
4. Run `flutter doctor` to verify installation

### macOS
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/macos)
2. Extract to desired location:
   ```bash
   cd ~/development
   unzip ~/Downloads/flutter_macos_3.x.x-stable.zip
   ```
3. Add to PATH in `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Run `flutter doctor` to verify installation

### Linux
1. Download Flutter SDK:
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
   tar xf flutter_linux_3.x.x-stable.tar.xz
   ```
2. Add to PATH in `~/.bashrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
3. Run `flutter doctor` to verify installation

## Project Setup

### 1. Clone the Repository
```bash
git clone https://github.com/naggeshsai/expense-tracker.git
cd expense-tracker
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
The project uses code generation for Drift database. Run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

If you need to watch for changes during development:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Verify Setup
```bash
flutter doctor
```

Fix any issues reported by flutter doctor before proceeding.

## Platform-Specific Setup

### Android Setup

1. **Install Android Studio**
   - Download from [developer.android.com](https://developer.android.com/studio)
   - Install Android SDK, SDK Platform Tools, and SDK Build Tools

2. **Accept Android Licenses**
   ```bash
   flutter doctor --android-licenses
   ```

3. **Create Virtual Device**
   - Open Android Studio
   - Go to Tools > Device Manager
   - Create a new virtual device (e.g., Pixel 5 with Android 13)

4. **Run on Android**
   ```bash
   flutter run
   ```

### iOS Setup (macOS only)

1. **Install Xcode**
   - Download from Mac App Store
   - Open Xcode and accept license agreement

2. **Install CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

3. **Setup iOS Simulator**
   ```bash
   open -a Simulator
   ```

4. **Run on iOS**
   ```bash
   flutter run
   ```

### Web Setup

1. **Enable Web Support**
   ```bash
   flutter config --enable-web
   ```

2. **Run on Web**
   ```bash
   flutter run -d chrome
   ```

### Windows Setup

1. **Install Visual Studio 2022**
   - Download Visual Studio 2022 Community
   - Install "Desktop development with C++" workload

2. **Enable Windows Support**
   ```bash
   flutter config --enable-windows-desktop
   ```

3. **Run on Windows**
   ```bash
   flutter run -d windows
   ```

## Running the Application

### Development Mode

**List Available Devices**
```bash
flutter devices
```

**Run on Specific Device**
```bash
# Android
flutter run -d <device-id>

# iOS Simulator
flutter run -d "iPhone 14"

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

**Hot Reload**
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

**Debug Mode**
```bash
flutter run --debug
```

**Profile Mode**
```bash
flutter run --profile
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS IPA (requires macOS and Xcode)
```bash
flutter build ios --release
```

Then archive in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Product > Archive
3. Distribute to App Store or Ad Hoc

### Web
```bash
flutter build web --release
```

Output: `build/web/`

Deploy to hosting service (Firebase Hosting, Netlify, etc.)

### Windows
```bash
flutter build windows --release
```

Output: `build/windows/runner/Release/`

## Troubleshooting

### Common Issues

**1. "Waiting for another flutter command to release the startup lock"**
```bash
rm -rf path/to/flutter/bin/cache/lockfile
```

**2. "Unable to find bundled Java version"**
- Set JAVA_HOME environment variable
- Point to Android Studio's JDK

**3. "CocoaPods not installed" (iOS)**
```bash
sudo gem install cocoapods
pod setup
```

**4. "Gradle build failed" (Android)**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**5. Code Generation Issues**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Performance Issues

**1. Slow Build Times**
- Enable incremental builds
- Use `--debug` for development
- Close unnecessary applications

**2. App Crashes**
- Check logs: `flutter logs`
- Run with verbose: `flutter run -v`
- Check for null safety issues

### Getting Help

- **Flutter Documentation**: [docs.flutter.dev](https://docs.flutter.dev)
- **Stack Overflow**: Tag with `flutter`
- **Flutter Community**: [discord.gg/flutter](https://discord.gg/flutter)
- **GitHub Issues**: Open an issue in this repository

## Development Tips

### VS Code Extensions
- Flutter
- Dart
- Flutter Widget Snippets
- Error Lens
- GitLens

### Android Studio Plugins
- Flutter
- Dart
- Rainbow Brackets

### Useful Commands
```bash
# Check for outdated packages
flutter pub outdated

# Update dependencies
flutter pub upgrade

# Analyze code
flutter analyze

# Format code
flutter format .

# Clean build artifacts
flutter clean

# Generate coverage report
flutter test --coverage
```

## Next Steps

After successful setup:
1. Run the app on your preferred platform
2. Explore the codebase structure
3. Read the [Architecture Documentation](ARCHITECTURE.md)
4. Check the [User Guide](USER_GUIDE.md) for feature overview
5. Start contributing!
