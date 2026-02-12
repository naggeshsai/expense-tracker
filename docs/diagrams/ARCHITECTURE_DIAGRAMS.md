# System Architecture Diagrams

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                           USER INTERFACE                            │
│                      (Flutter Material Design 3)                    │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────────┐
│                      PRESENTATION LAYER                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐  │
│  │ Dashboard  │  │  Expenses  │  │   Budget   │  │  Settings  │  │
│  │    Page    │  │    Page    │  │    Page    │  │    Page    │  │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘  │
│        └────────────────┴────────────────┴────────────────┘         │
│                               │                                     │
│  ┌────────────────────────────▼───────────────────────────────┐    │
│  │              State Management (BLoC/Cubit)                 │    │
│  │   ExpenseBloc │ CategoryCubit │ BudgetCubit │ SettingsCubit│   │
│  └────────────────────────────┬───────────────────────────────┘    │
└───────────────────────────────┼────────────────────────────────────┘
                                │
┌───────────────────────────────▼────────────────────────────────────┐
│                         DOMAIN LAYER                               │
│                     (Business Logic Core)                          │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │                      Use Cases                               │  │
│  │  • Get/Add/Update/Delete Expenses                           │  │
│  │  • Get/Add/Update/Delete Categories                         │  │
│  │  • Get/Add/Update/Delete Budgets                            │  │
│  │  • Calculate Total Spending                                 │  │
│  │  • Get Category-wise Spending                               │  │
│  └──────────────────────────┬──────────────────────────────────┘  │
│                             │                                      │
│  ┌──────────────────────────▼──────────────────────────────────┐  │
│  │            Repository Interfaces (Contracts)                │  │
│  │  • ExpenseRepository  • CategoryRepository  • BudgetRepository│ │
│  └──────────────────────────┬──────────────────────────────────┘  │
│                             │                                      │
│  ┌──────────────────────────▼──────────────────────────────────┐  │
│  │                      Entities                               │  │
│  │     Expense    │    Category    │    Budget                 │  │
│  └─────────────────────────────────────────────────────────────┘  │
└───────────────────────────────┬────────────────────────────────────┘
                                │
┌───────────────────────────────▼────────────────────────────────────┐
│                          DATA LAYER                                │
│                   (Data Sources & Persistence)                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │           Repository Implementations                        │  │
│  │  ExpenseRepositoryImpl │ CategoryRepositoryImpl │           │  │
│  │  BudgetRepositoryImpl                                       │  │
│  └──────────────────────────┬──────────────────────────────────┘  │
│                             │                                      │
│  ┌──────────────────────────▼──────────────────────────────────┐  │
│  │           Data Access Objects (DAOs)                        │  │
│  │    ExpenseDao   │   CategoryDao   │   BudgetDao            │  │
│  └──────────────────────────┬──────────────────────────────────┘  │
│                             │                                      │
│  ┌──────────────────────────▼──────────────────────────────────┐  │
│  │              Drift Database (SQLite)                        │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │  │
│  │  │ Expenses │  │Categories│  │ Budgets  │                 │  │
│  │  │  Table   │  │  Table   │  │  Table   │                 │  │
│  │  └──────────┘  └──────────┘  └──────────┘                 │  │
│  └─────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │  Local Storage (DB)   │
                    │  expense_tracker.db   │
                    └───────────────────────┘
```

## Data Flow Diagram - Add Expense

```
┌──────┐       ┌────────────┐      ┌──────────┐      ┌────────────┐      ┌──────────┐
│ User │──────>│Add Expense │─────>│ Expense  │─────>│   Use      │─────>│Repository│
│      │ Taps  │   Page     │Event │  Bloc    │Call  │   Case     │Call  │   Impl   │
└──────┘  +    └────────────┘      └──────────┘      └────────────┘      └────┬─────┘
                                                                                │
                                                                                ▼
                                                                          ┌──────────┐
                                                                          │   DAO    │
                                                                          └────┬─────┘
                                                                               │
                                                                               ▼
                                                                          ┌──────────┐
                                                                          │ Database │
                                                                          │  INSERT  │
                                                                          └────┬─────┘
                                                                               │
┌──────┐       ┌────────────┐      ┌──────────┐      ┌────────────┐      ┌───▼──────┐
│ User │<──────│   Shows    │<─────│ Expense  │<─────│  Success   │<─────│  Result  │
│      │Success│  Snackbar  │State │  Bloc    │      │  Response  │      │          │
└──────┘       └────────────┘      └──────────┘      └────────────┘      └──────────┘
```

## State Management Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         BLoC Pattern                            │
└─────────────────────────────────────────────────────────────────┘

User Action
    │
    ▼
┌─────────┐
│  Event  │ (e.g., AddExpense, LoadExpenses)
└────┬────┘
     │
     ▼
┌──────────┐
│   BLoC   │ (Business Logic Component)
│          │ • Receives events
│          │ • Calls use cases
│          │ • Emits states
└────┬─────┘
     │
     ▼
┌─────────┐
│  State  │ (e.g., ExpenseLoading, ExpenseLoaded, ExpenseError)
└────┬────┘
     │
     ▼
   UI Updates


┌─────────────────────────────────────────────────────────────────┐
│                        Cubit Pattern                            │
└─────────────────────────────────────────────────────────────────┘

User Action
    │
    ▼
┌──────────────┐
│ Method Call  │ (e.g., loadCategories(), addBudget())
└──────┬───────┘
       │
       ▼
┌────────────┐
│   Cubit    │ (Simplified BLoC)
│            │ • Receives method calls
│            │ • Calls use cases
│            │ • Emits states
└──────┬─────┘
       │
       ▼
┌─────────┐
│  State  │ (e.g., CategoryLoading, CategoryLoaded)
└────┬────┘
     │
     ▼
  UI Updates
```

## Dependency Injection Flow

```
┌───────────────────────────────────────────────────────────┐
│                    Dependency Graph                       │
└───────────────────────────────────────────────────────────┘

                     ┌──────────────┐
                     │   GetIt      │
                     │  Container   │
                     └───────┬──────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
    ┌─────────┐         ┌─────────┐        ┌─────────┐
    │Database │         │  DAOs   │        │  Repos  │
    │         │────────>│         │───────>│         │
    └─────────┘         └─────────┘        └────┬────┘
    Singleton            Singleton              │
                                                 │
                                                 ▼
                                            ┌─────────┐
                                            │   Use   │
                                            │  Cases  │
                                            └────┬────┘
                                            Singleton
                                                 │
                                                 ▼
                                            ┌─────────┐
                                            │  BLoCs  │
                                            │ /Cubits │
                                            └─────────┘
                                             Factory
                                            (New per
                                             screen)
```

## Database Schema Relationships

```
┌────────────────────┐
│    Categories      │
│                    │
│ • id (PK)          │
│ • name             │
│ • icon             │
│ • color            │
│ • is_custom        │
│ • created_at       │
└─────────┬──────────┘
          │
          │ 1
          │
          │ Many
          │
┌─────────▼──────────┐              ┌────────────────────┐
│     Expenses       │              │     Budgets        │
│                    │              │                    │
│ • id (PK)          │              │ • id (PK)          │
│ • amount           │              │ • category_id (FK) │ ◄──┐
│ • category_id (FK) │ ◄────────────┤ • amount           │    │
│ • note             │      1:Many  │ • month            │    │
│ • date             │              │ • year             │    │
│ • payment_method   │              │ • created_at       │    │
│ • is_recurring     │              │ • updated_at       │    │
│ • created_at       │              └────────────────────┘    │
│ • updated_at       │                                        │
│ • is_synced        │                                        │
└────────────────────┘                                        │
                                                              │
                      Optional (null = overall budget) ───────┘
```

## Navigation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      App Launch                             │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
                    ┌────────────┐
                    │  Seed DB   │
                    │ Categories │
                    └──────┬─────┘
                           │
                           ▼
                    ┌────────────┐
                    │ Home Page  │
                    └──────┬─────┘
                           │
        ┌──────────────────┼─────────────────┐
        │                  │                 │
        ▼                  ▼                 ▼
┌──────────────┐   ┌──────────────┐  ┌──────────────┐
│  Dashboard   │   │   Expenses   │  │    Budget    │
│              │   │              │  │              │
│  • Charts    │   │ • List View  │  │ • Progress   │
│  • Analytics │   │ • Add/Edit   │  │   Bars       │
│  • Summary   │   │ • Delete     │  │ • Set Budget │
└──────────────┘   └──────────────┘  └──────────────┘
        │                  │
        │                  ▼
        │          ┌──────────────┐
        │          │ Add Expense  │
        │          │    Page      │
        │          └──────────────┘
        │
        ▼
┌──────────────┐
│   Settings   │
│              │
│ • Theme      │
│ • Currency   │
│ • Export     │
│ • Clear Data │
└──────────────┘
```

## Feature Modules

```
┌─────────────────────────────────────────────────────────────┐
│                    Feature Breakdown                        │
└─────────────────────────────────────────────────────────────┘

├── Expense Management
│   ├── Add Expense
│   ├── Edit Expense
│   ├── Delete Expense
│   ├── View Expenses
│   └── Filter Expenses
│
├── Category Management
│   ├── View Categories
│   ├── Add Custom Category
│   ├── Edit Custom Category
│   └── Delete Custom Category
│
├── Budget Management
│   ├── Set Overall Budget
│   ├── Set Category Budget
│   ├── View Budget Status
│   └── Budget Alerts
│
├── Dashboard & Analytics
│   ├── Total Spending
│   ├── Pie Chart (Category Breakdown)
│   ├── Bar Chart (Daily Spending)
│   ├── Line Chart (Monthly Trend)
│   └── Date Range Filter
│
└── Settings
    ├── Theme Selection
    ├── Currency Selection
    ├── Export to CSV
    └── Clear All Data
```
