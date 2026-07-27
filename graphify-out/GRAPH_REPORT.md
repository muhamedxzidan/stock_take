# Graph Report - stock_take  (2026-07-27)

## Corpus Check
- 52 files · ~9,078 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 582 nodes · 809 edges · 33 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `13fc37f9`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_strings.dart
- StatelessWidget
- app_router.dart
- TransactionsCubit
- app_sizes.dart
- main.dart
- app_colors.dart
- add_item_form.dart
- DashboardCubit
- transaction_model.dart
- transactions_cubit.dart
- item_model.dart
- package:flutter_bloc/flutter_bloc.dart
- pdf_voucher_dialog.dart
- adjustment_form.dart
- inbound_form.dart
- outbound_form.dart
- stock_summary_card.dart
- dashboard_repository.dart
- custom_text_field.dart
- transactions_repository.dart
- dashboard_cubit.dart
- status_badge.dart
- custom_button.dart
- transaction_list_item.dart
- app_routes.dart
- tablet_navigation_rail.dart
- custom_app_bar.dart
- package:flutter/material.dart
- transactions_state.dart
- TransactionsCubit
- Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها
- Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك

## God Nodes (most connected - your core abstractions)
1. `TransactionsCubit` - 22 edges
2. `DashboardCubit` - 12 edges
3. `ItemsCubit` - 11 edges
4. `DashboardState` - 6 edges
5. `ItemsState` - 6 edges
6. `TransactionsState` - 6 edges
7. `StockTakeApp` - 5 edges
8. `_AddItemFormState` - 4 edges
9. `_AdjustmentFormState` - 4 edges
10. `_InboundFormState` - 4 edges

## Surprising Connections (you probably didn't know these)
- `build` --references--> `DashboardCubit`  [EXTRACTED]
  lib/features/dashboard/presentation/screens/dashboard_screen.dart → lib/features/dashboard/cubit/dashboard_cubit.dart
- `StockTakeApp` --references--> `DashboardCubit`  [EXTRACTED]
  lib/main.dart → lib/features/dashboard/cubit/dashboard_cubit.dart
- `StockTakeApp` --references--> `ItemsCubit`  [EXTRACTED]
  lib/main.dart → lib/features/items/cubit/items_cubit.dart
- `TransactionsCubit` --calls--> `TransactionsFailure`  [EXTRACTED]
  lib/features/transactions/cubit/transactions_cubit.dart → lib/features/transactions/cubit/transactions_state.dart
- `TransactionsCubit` --calls--> `TransactionsLoading`  [EXTRACTED]
  lib/features/transactions/cubit/transactions_cubit.dart → lib/features/transactions/cubit/transactions_state.dart

## Import Cycles
- None detected.

## Communities (33 total, 0 thin omitted)

### Community 0 - "app_strings.dart"
Cohesion: 0.03
Nodes (58): actualCount, addItemTitle, adjustmentReason, adjustmentTitle, AppStrings, appTitle, cancel, cartonCount (+50 more)

### Community 1 - "StatelessWidget"
Cohesion: 0.09
Nodes (26): ../../../../core/constants/app_sizes.dart, core/constants/app_strings.dart, ../../../../core/shared_widgets/custom_app_bar.dart, CustomAppBar, CustomTextField, AddItemScreen, build, build (+18 more)

### Community 2 - "app_router.dart"
Cohesion: 0.07
Nodes (27): app_routes.dart, ../../features/dashboard/presentation/screens/dashboard_screen.dart, ../../features/items/presentation/screens/add_item_screen.dart, ../../features/returns/presentation/screens/warehouse_return_screen.dart, ../../features/transactions/presentation/screens/inbound_entry_screen.dart, ../../features/transactions/presentation/screens/outbound_entry_screen.dart, ../../features/transactions/presentation/screens/stock_adjustment_screen.dart, ../../features/transactions/presentation/screens/transaction_history_screen.dart (+19 more)

### Community 3 - "TransactionsCubit"
Cohesion: 0.29
Nodes (6): ../../cubit/transactions_cubit.dart, ../../cubit/transactions_state.dart, ../../data/models/transaction_model.dart, build, _buildFilterChip, TransactionFilterBar

### Community 4 - "app_sizes.dart"
Cohesion: 0.06
Nodes (31): AppSizes, buttonHeight, cardElevation, h12, h16, h20, h24, h32 (+23 more)

### Community 5 - "main.dart"
Cohesion: 0.08
Nodes (24): app_colors.dart, core/constants/app_router.dart, core/theme/app_theme.dart, features/dashboard/cubit/dashboard_cubit.dart, features/dashboard/data/repositories/dashboard_repository.dart, features/items/cubit/items_cubit.dart, features/items/data/repositories/items_repository.dart, features/transactions/cubit/transactions_cubit.dart (+16 more)

### Community 6 - "app_colors.dart"
Cohesion: 0.08
Nodes (24): AppColors, background, border, divider, error, errorBackground, info, infoBackground (+16 more)

### Community 7 - "add_item_form.dart"
Cohesion: 0.08
Nodes (25): ../../data/models/warehouse_return_draft.dart, build, children, _condition, _conditionColor, _conditionLabel, createState, _dateController (+17 more)

### Community 8 - "DashboardCubit"
Cohesion: 0.13
Nodes (20): ../../../../core/constants/app_routes.dart, ../../cubit/dashboard_cubit.dart, ../../cubit/dashboard_state.dart, ../../data/models/item_model.dart, DashboardCubit, DashboardFailure, DashboardInitial, DashboardLoading (+12 more)

### Community 9 - "transaction_model.dart"
Cohesion: 0.12
Nodes (15): actorName, date, fromJson, id, itemCode, itemId, itemName, notes (+7 more)

### Community 10 - "transactions_cubit.dart"
Cohesion: 0.13
Nodes (14): ../data/repositories/transactions_repository_base.dart, _allLogs, _applyFilterAndQuery, close, createAdjustmentTransaction, createInboundTransaction, createOutboundTransaction, _currentFilter (+6 more)

### Community 11 - "item_model.dart"
Cohesion: 0.13
Nodes (14): int get, code, copyWith, currentStockBalance, fromJson, id, ItemModel, itemsPerCarton (+6 more)

### Community 12 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.07
Nodes (33): Cubit, ../../cubit/items_cubit.dart, ../../cubit/items_state.dart, ../../../dashboard/data/models/item_model.dart, ../data/repositories/items_repository_base.dart, items_repository_base.dart, items_state.dart, ItemsCubit (+25 more)

### Community 13 - "pdf_voucher_dialog.dart"
Cohesion: 0.13
Nodes (14): ../constants/app_strings.dart, build, _buildRow, date, deliveredBy, driverName, itemName, partyName (+6 more)

### Community 14 - "adjustment_form.dart"
Cohesion: 0.18
Nodes (11): ../../../../core/shared_widgets/custom_button.dart, ../../../../core/shared_widgets/custom_text_field.dart, _actualCountController, AdjustmentForm, _AdjustmentFormState, createState, dispose, _itemCodeController (+3 more)

### Community 15 - "inbound_form.dart"
Cohesion: 0.15
Nodes (13): createState, _dateController, _deliveredByController, dispose, _driverNameController, InboundForm, _InboundFormState, _itemCodeController (+5 more)

### Community 16 - "outbound_form.dart"
Cohesion: 0.15
Nodes (13): createState, _dateController, _dispatchedByController, dispose, _driverNameController, _itemCodeController, _itemNameController, OutboundForm (+5 more)

### Community 17 - "stock_summary_card.dart"
Cohesion: 0.06
Nodes (29): ../../../../core/constants/app_colors.dart, ../../../../core/constants/app_text_styles.dart, ../../../../core/shared_widgets/pdf_voucher_dialog.dart, ../../../../core/shared_widgets/status_badge.dart, ../../data/models/stock_summary_model.dart, fromJson, lowStockItemsCount, StockSummaryModel (+21 more)

### Community 18 - "dashboard_repository.dart"
Cohesion: 0.20
Nodes (10): dashboard_repository_base.dart, DashboardRepositoryBase, fetchItems, fetchStockSummary, DashboardRepository, fetchItems, fetchStockSummary, _items (+2 more)

### Community 19 - "custom_text_field.dart"
Cohesion: 0.15
Nodes (12): build, controller, hint, keyboardType, label, maxLines, onChanged, prefixIcon (+4 more)

### Community 20 - "transactions_repository.dart"
Cohesion: 0.18
Nodes (10): createTransaction, fetchTransactions, TransactionsRepositoryBase, createTransaction, fetchTransactions, _logs, TransactionsRepository, List (+2 more)

### Community 21 - "dashboard_cubit.dart"
Cohesion: 0.18
Nodes (10): dart:async, dashboard_state.dart, ../data/repositories/dashboard_repository_base.dart, _allItems, close, _debounceTimer, loadDashboardData, onSearchChanged (+2 more)

### Community 22 - "status_badge.dart"
Cohesion: 0.20
Nodes (9): Color, adjustment, backgroundColor, build, inbound, label, outbound, StatusBadge (+1 more)

### Community 23 - "custom_button.dart"
Cohesion: 0.22
Nodes (8): backgroundColor, build, CustomButton, icon, isLoading, onPressed, text, VoidCallback

### Community 24 - "transaction_list_item.dart"
Cohesion: 0.13
Nodes (14): int?, condition, itemCode, itemName, notes, originalVoucherNumber, quantity, reason (+6 more)

### Community 25 - "app_routes.dart"
Cohesion: 0.20
Nodes (9): addItem, AppRoutes, dashboard, inboundEntry, outboundEntry, stockAdjustment, transactionHistory, warehouseReturn (+1 more)

### Community 26 - "tablet_navigation_rail.dart"
Cohesion: 0.29
Nodes (6): ../constants/app_routes.dart, ../constants/app_sizes.dart, build, _buildNavItem, currentRoute, TabletNavigationRail

### Community 27 - "custom_app_bar.dart"
Cohesion: 0.20
Nodes (9): ../constants/app_colors.dart, ../constants/app_text_styles.dart, actions, build, preferredSize, title, AppTheme, package:flutter/material.dart (+1 more)

### Community 28 - "package:flutter/material.dart"
Cohesion: 0.20
Nodes (9): IconData, build, _buildActionButton, color, icon, _QuickAction, QuickActionBar, route (+1 more)

### Community 29 - "transactions_state.dart"
Cohesion: 0.29
Nodes (9): message, selectedFilter, transactions, TransactionsFailure, TransactionsInitial, TransactionsLoading, TransactionsState, TransactionsSuccess (+1 more)

### Community 30 - "TransactionsCubit"
Cohesion: 0.25
Nodes (10): build, TransactionsCubit, build, TransactionHistoryScreen, build, build, build, AppRoutes.transactionHistory (+2 more)

### Community 31 - "Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها, Source Nodes

### Community 32 - "Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك, Source Nodes

## Knowledge Gaps
- **357 isolated node(s):** `AppColors`, `primary`, `primaryLight`, `primaryDark`, `secondary` (+352 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `TransactionsCubit` connect `TransactionsCubit` to `TransactionsCubit`, `main.dart`, `transactions_cubit.dart`, `package:flutter_bloc/flutter_bloc.dart`, `adjustment_form.dart`, `inbound_form.dart`, `outbound_form.dart`, `transactions_state.dart`?**
  _High betweenness centrality (0.047) - this node is a cross-community bridge._
- **Why does `ReturnItemCondition` connect `transaction_list_item.dart` to `add_item_form.dart`?**
  _High betweenness centrality (0.039) - this node is a cross-community bridge._
- **Why does `ItemsCubit` connect `package:flutter_bloc/flutter_bloc.dart` to `main.dart`?**
  _High betweenness centrality (0.030) - this node is a cross-community bridge._
- **What connects `AppColors`, `primary`, `primaryLight` to the rest of the system?**
  _357 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_strings.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03389830508474576 - nodes in this community are weakly interconnected._
- **Should `StatelessWidget` be split into smaller, more focused modules?**
  _Cohesion score 0.09247311827956989 - nodes in this community are weakly interconnected._
- **Should `app_router.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06666666666666667 - nodes in this community are weakly interconnected._