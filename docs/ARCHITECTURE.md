# Expense Tracker - Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Component Diagram](#component-diagram)
4. [Flow Diagrams](#flow-diagrams)
5. [Database Schema](#database-schema)

## Overview

The Expense Tracker is a cross-platform application built with Flutter that follows Clean Architecture principles. It provides comprehensive expense tracking, budgeting, and financial analytics features with offline-first local storage.

## Architecture

The application follows **Clean Architecture** with three main layers:

### 1. Presentation Layer
- **Pages**: UI screens for different features
- **Widgets**: Reusable UI components
- **BLoC/Cubit**: State management using flutter_bloc
- Handles user interactions and displays data

### 2. Domain Layer
- **Entities**: Core business models
- **Repositories**: Abstract interfaces
- **Use Cases**: Business logic operations
- Pure Dart, no dependencies on external frameworks

### 3. Data Layer
- **Models**: Data transfer objects with mappers
- **DAOs**: Data Access Objects for database operations
- **Repository Implementations**: Concrete implementations of domain repositories
- **Local Database**: Drift (SQLite) for persistent storage

## Component Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │Dashboard │  │ Expenses │  │  Budget  │  │ Settings │      │
│  │   Page   │  │   Page   │  │   Page   │  │   Page   │      │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘      │
│       │             │              │              │            │
│  ┌────▼─────────────▼──────────────▼──────────────▼─────┐     │
│  │                  BLoC / Cubit                         │     │
│  │  - ExpenseBloc  - CategoryCubit  - BudgetCubit       │     │
│  │  - DashboardCubit  - SettingsCubit                   │     │
│  └────────────────────┬──────────────────────────────────┘     │
│                       │                                        │
└───────────────────────┼────────────────────────────────────────┘
                        │
┌───────────────────────▼────────────────────────────────────────┐
│                       DOMAIN LAYER                             │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌──────────────────────────────────────────────────────┐     │
│  │                   Use Cases                          │     │
│  │  - GetAllExpenses    - AddExpense                   │     │
│  │  - GetAllCategories  - AddCategory                  │     │
│  │  - GetAllBudgets     - AddBudget                    │     │
│  │  - GetTotalSpending  - GetCategorySpending         │     │
│  └────────────────────┬─────────────────────────────────┘     │
│                       │                                        │
│  ┌────────────────────▼─────────────────────────────────┐     │
│  │           Repository Interfaces                      │     │
│  │  - ExpenseRepository                                 │     │
│  │  - CategoryRepository                                │     │
│  │  - BudgetRepository                                  │     │
│  └────────────────────┬─────────────────────────────────┘     │
│                       │                                        │
│  ┌────────────────────▼─────────────────────────────────┐     │
│  │                  Entities                            │     │
│  │  - Expense  - Category  - Budget                    │     │
│  └──────────────────────────────────────────────────────┘     │
│                                                                │
└───────────────────────┬────────────────────────────────────────┘
                        │
┌───────────────────────▼────────────────────────────────────────┐
│                        DATA LAYER                              │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌──────────────────────────────────────────────────────┐     │
│  │         Repository Implementations                   │     │
│  │  - ExpenseRepositoryImpl                            │     │
│  │  - CategoryRepositoryImpl                           │     │
│  │  - BudgetRepositoryImpl                             │     │
│  └────────────────────┬─────────────────────────────────┘     │
│                       │                                        │
│  ┌────────────────────▼─────────────────────────────────┐     │
│  │            Data Access Objects (DAOs)                │     │
│  │  - ExpenseDao  - CategoryDao  - BudgetDao          │     │
│  └────────────────────┬─────────────────────────────────┘     │
│                       │                                        │
│  ┌────────────────────▼─────────────────────────────────┐     │
│  │              Drift Database (SQLite)                 │     │
│  │  - Expenses Table                                    │     │
│  │  - Categories Table                                  │     │
│  │  - Budgets Table                                     │     │
│  └──────────────────────────────────────────────────────┘     │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

## Flow Diagrams

### 1. Add Expense Flow

```
User                AddExpensePage         ExpenseBloc          Repository          Database
  │                      │                      │                   │                  │
  ├──Opens Add Page─────>│                      │                   │                  │
  │                      │                      │                   │                  │
  ├──Fills Form─────────>│                      │                   │                  │
  │                      │                      │                   │                  │
  ├──Taps Save──────────>│                      │                   │                  │
  │                      │                      │                   │                  │
  │                      ├──AddExpense Event──>│                   │                  │
  │                      │                      │                   │                  │
  │                      │                      ├──addExpense()────>│                  │
  │                      │                      │                   │                  │
  │                      │                      │                   ├──INSERT────────>│
  │                      │                      │                   │                  │
  │                      │                      │                   │<──Success───────┤
  │                      │                      │                   │                  │
  │                      │                      │<──Success─────────┤                  │
  │                      │                      │                   │                  │
  │                      │<──Success State──────┤                   │                  │
  │                      │                      │                   │                  │
  │<──Navigates Back─────┤                      │                   │                  │
  │                      │                      │                   │                  │
  │<──Shows Snackbar─────┤                      │                   │                  │
  │                      │                      │                   │                  │
```

### 2. Dashboard Data Loading Flow

```
User              DashboardPage      DashboardCubit     Repository        Database
  │                    │                   │                │               │
  ├──Opens Dashboard──>│                   │                │               │
  │                    │                   │                │               │
  │                    ├──loadData()──────>│                │               │
  │                    │                   │                │               │
  │                    │                   ├──getTotalSpending()───>│      │
  │                    │                   │                │               │
  │                    │                   │                ├──QUERY───────>│
  │                    │                   │                │               │
  │                    │                   │                │<──Result──────┤
  │                    │                   │                │               │
  │                    │                   │<──Total────────┤               │
  │                    │                   │                │               │
  │                    │                   ├──getCategorySpending()──>│     │
  │                    │                   │                │               │
  │                    │                   │                ├──QUERY───────>│
  │                    │                   │                │               │
  │                    │                   │                │<──Result──────┤
  │                    │                   │                │               │
  │                    │                   │<──Map──────────┤               │
  │                    │                   │                │               │
  │                    │<──Updated State───┤                │               │
  │                    │                   │                │               │
  │<──Displays Charts──┤                   │                │               │
  │                    │                   │                │               │
```

### 3. Budget Tracking Flow

```
User              BudgetPage         BudgetCubit        Repository        Database
  │                   │                   │                 │                │
  ├──Opens Budget────>│                   │                 │                │
  │                   │                   │                 │                │
  │                   ├──loadBudgets()───>│                 │                │
  │                   │                   │                 │                │
  │                   │                   ├──getAllBudgets()──────>│         │
  │                   │                   │                 │                │
  │                   │                   │                 ├──SELECT───────>│
  │                   │                   │                 │                │
  │                   │                   │                 │<──Budgets──────┤
  │                   │                   │                 │                │
  │                   │                   │<──List─────────┤                │
  │                   │                   │                 │                │
  │                   │<──Loaded State────┤                 │                │
  │                   │                   │                 │                │
  │<──Display Progress─┤                  │                 │                │
  │   Bars            │                   │                 │                │
  │                   │                   │                 │                │
  ├──Set New Budget──>│                   │                 │                │
  │                   │                   │                 │                │
  │                   ├──addBudget()─────>│                 │                │
  │                   │                   │                 │                │
  │                   │                   ├──addBudget()───────────>│        │
  │                   │                   │                 │                │
  │                   │                   │                 ├──INSERT───────>│
  │                   │                   │                 │                │
  │                   │                   │                 │<──Success──────┤
  │                   │                   │                 │                │
  │                   │                   │<──Success───────┤                │
  │                   │                   │                 │                │
  │                   │<──Reload──────────┤                 │                │
  │                   │                   │                 │                │
```

## Database Schema

### Expenses Table
```sql
CREATE TABLE expenses (
  id TEXT PRIMARY KEY,
  amount REAL NOT NULL,
  category_id TEXT NOT NULL,
  note TEXT,
  date DATETIME NOT NULL,
  payment_method TEXT NOT NULL,
  is_recurring BOOLEAN DEFAULT 0,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  is_synced BOOLEAN DEFAULT 0,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

### Categories Table
```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  color INTEGER NOT NULL,
  is_custom BOOLEAN DEFAULT 0,
  created_at DATETIME NOT NULL
);
```

### Budgets Table
```sql
CREATE TABLE budgets (
  id TEXT PRIMARY KEY,
  category_id TEXT,
  amount REAL NOT NULL,
  month INTEGER NOT NULL,
  year INTEGER NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

## State Management Pattern

### BLoC Pattern (for Expenses)
- **Events**: User actions that trigger state changes
- **States**: Different states of the UI
- **Bloc**: Business logic that transforms events into states

### Cubit Pattern (for Categories, Budget, Settings)
- Simplified version of BLoC
- Direct method calls instead of events
- Better for simpler state management

## Dependency Injection

Uses **GetIt** for dependency injection:
- Singleton instances for repositories and use cases
- Factory instances for BLoCs/Cubits (new instance per screen)

## Data Flow

1. User interacts with UI (Presentation Layer)
2. UI triggers BLoC/Cubit method
3. BLoC/Cubit calls Use Case (Domain Layer)
4. Use Case calls Repository interface (Domain Layer)
5. Repository implementation handles data (Data Layer)
6. DAO executes database query (Data Layer)
7. Result flows back up the chain
8. UI updates based on new state
