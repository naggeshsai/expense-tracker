import 'package:flutter/material.dart';
import 'app.dart';
import 'injection_container.dart';
import 'domain/usecases/category_usecases.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  await setupDependencies();
  
  // Seed default categories on first launch
  try {
    final seedCategoriesUseCase = sl<SeedDefaultCategoriesUseCase>();
    await seedCategoriesUseCase();
  } catch (e) {
    debugPrint('Error seeding categories: $e');
  }
  
  runApp(const ExpenseTrackerApp());
}
