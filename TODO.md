# TODO - Expense Tracker

## High Priority

- [ ] **Implement CSV Export**: `Settings > Export Data` currently shows "coming soon!" — needs actual CSV generation using the `csv` package, writing to file, and sharing/downloading
- [ ] **Implement Clear All Data**: `Settings > Clear All Data` shows "coming soon!" — needs to actually call delete methods on expense, budget, and category repositories
- [ ] **Implement Add Budget Dialog**: `BudgetPage` FAB has a placeholder `// TODO: Implement add budget dialog` — needs a form with amount, category dropdown, and month/year picker
- [ ] **Calculate actual spending for budgets**: `BudgetPage` uses mock data (`// For now, using mock data`) — needs to query real expense totals for each budget's category and time period
- [ ] **Implement expense filter dialog**: `ExpenseListPage` has `// TODO: Implement filter dialog` — needs filter by date range, category, and payment method

## Medium Priority

- [ ] **Daily bar chart with real data**: `SpendingBarChart` exists but needs integration with real daily spending queries from the database
- [ ] **6-month line chart with real data**: `SpendingLineChart` exists but needs actual monthly aggregation queries
- [ ] **Quick stats on dashboard**: Today's spend, week's spend, and average daily spend are not calculated — need new use cases and dashboard cubit updates
- [ ] **Add Custom Category Dialog**: Category page needs a working form dialog to create custom categories with name, icon picker, and color picker
- [ ] **Recurring expense automation**: The `isRecurring` flag exists on expenses but no scheduler or automation copies recurring expenses to new periods
- [x] **Show category name on pie chart hover**: When hovering/touching a category in the spending pie chart, show the category name as a tooltip
- [ ] **Open expense detail from person debt page**: When viewing a person's debt detail and tapping on an individual expense, it should navigate to the Add/Edit Expense page with that transaction's details — currently tapping does nothing

## Low Priority

- [ ] **Receipt attachments**: Allow users to attach photos of receipts to expenses
- [ ] **Income tracking**: Add ability to track income alongside expenses
- [ ] **Shared budgets**: Support for shared budget tracking between multiple users
- [ ] **Advanced reports**: Custom date range reports with PDF/Excel export
- [ ] **AI-powered insights**: Smart spending analysis and recommendations
- [ ] **Multi-currency support**: Handle expenses in different currencies with conversion
- [ ] **Integration tests**: Add end-to-end integration tests for critical user flows
- [ ] **Pagination**: Add pagination for large expense lists to improve performance
- [ ] **Accessibility**: Add semantic labels, test with screen readers, ensure proper contrast ratios
- [ ] **Splash screen & app icon**: Add branded splash screen and custom app icon

## Phase 2 — Cloud Sync

- [ ] **Cloud synchronization**: Implement sync with Supabase/Firebase backend
- [ ] **User authentication**: Sign in with email/Google/Apple
- [ ] **Multi-device support**: Sync data across devices
- [ ] **Backup and restore**: Cloud-based backup and restore
- [ ] **Conflict resolution**: Handle merge conflicts when syncing from multiple devices
