# Graph Report - stock_take  (2026-07-28)

## Corpus Check
- 81 files · ~16,279 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 939 nodes · 1333 edges · 65 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `726c99a1`
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
- package:flutter/material.dart
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
- item_quantity_sheet.dart
- movement_ui_types.dart
- items_cubit.dart
- ../../../../core/models/inventory_item.dart
- movement_type_selector.dart
- current_voucher_panel.dart
- movement_voucher_preview_dialog.dart
- selectable_item_card.dart
- ../../../../core/constants/app_colors.dart
- Q: اضافه اسم السائق في الاستلام والتسليم
- Q: العميل عاوز يبسط الامور جدا بحيث العامل يفتخ السيستم لما يجي يدوس علي منتج يطلعلو عاوز كام منو هياخد ولا هيخصم منو وبناء علي طلبو هيتحمع في الفاتوره عاوزها مبسطه خالص اقترحلي ال UI
- Q: اعمل الخطه ك ui. بس
- login_screen.dart
- item_model.dart
- transaction_list_item.dart
- firebase_auth_repository.dart
- package:flutter_bloc/flutter_bloc.dart
- Q: نفذ خطة UI المبسطة للحركة متعددة الأصناف فقط
- Q: بعد الضغط على الاستكمال والمعاينة والطباعة هل يطبع ويخصم للمنصرف أو يزيد للوارد ثم يفرغ الأصناف المختارة؟
- Q: عاوز يكون في حاجه للمرتجع وحاجه لجرد المخزن
- adjustment_form.dart
- ../constants/app_colors.dart
- ../../../dashboard/data/models/item_model.dart
- responsive_layout.dart
- dashboard_screen.dart
- auth_failure.dart
- Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه
- auth_session_notifier.dart
- stock_summary_model.dart
- State
- login_cubit.dart
- build

## God Nodes (most connected - your core abstractions)
1. `TransactionsCubit` - 23 edges
2. `DashboardCubit` - 18 edges
3. `LoginCubit` - 12 edges
4. `ItemsCubit` - 12 edges
5. `MovementKind` - 7 edges
6. `LoginState` - 6 edges
7. `DashboardState` - 6 edges
8. `ItemsState` - 6 edges
9. `TransactionsState` - 6 edges
10. `ItemsRepositoryBase` - 5 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `DashboardCubit`  [EXTRACTED]
  lib/features/dashboard/presentation/screens/dashboard_screen.dart → lib/features/dashboard/cubit/dashboard_cubit.dart
- `build` --references--> `TransactionsCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/transaction_history_screen.dart → lib/features/transactions/cubit/transactions_cubit.dart
- `AppRouter` --references--> `LoginCubit`  [EXTRACTED]
  lib/core/constants/app_router.dart → lib/features/auth/cubit/login/login_cubit.dart
- `_submit` --references--> `LoginCubit`  [EXTRACTED]
  lib/features/auth/presentation/screens/login_screen.dart → lib/features/auth/cubit/login/login_cubit.dart
- `build` --references--> `DashboardCubit`  [EXTRACTED]
  lib/features/dashboard/presentation/screens/dashboard_screen.dart → lib/features/dashboard/cubit/dashboard_cubit.dart

## Import Cycles
- None detected.

## Communities (65 total, 0 thin omitted)

### Community 0 - "app_strings.dart"
Cohesion: 0.03
Nodes (79): actualCount, addItemTitle, adjustmentReason, adjustmentTitle, AppStrings, appTitle, authorizedUsersOnly, backToNewMovement (+71 more)

### Community 1 - "StatelessWidget"
Cohesion: 0.13
Nodes (14): dashboard_state.dart, ../../data/models/stock_summary_model.dart, ../data/repositories/dashboard_repository_base.dart, _allItems, _buildSummary, close, _debounceTimer, _emitFilteredItems (+6 more)

### Community 2 - "app_router.dart"
Cohesion: 0.20
Nodes (9): GoRouterState, build, child, _confirmLogout, MainShellScreen, state, ../responsive/responsive_layout.dart, tablet_navigation_rail.dart (+1 more)

### Community 3 - "TransactionsCubit"
Cohesion: 0.17
Nodes (11): ../../../../core/shared_widgets/custom_text_field.dart, ../../cubit/transactions_cubit.dart, ../../cubit/transactions_state.dart, ../../data/models/transaction_model.dart, build, TransactionHistoryScreen, build, _buildFilterChip (+3 more)

### Community 4 - "app_sizes.dart"
Cohesion: 0.04
Nodes (44): app_colors.dart, AppSizes, buttonHeight, cardElevation, h12, h16, h20, h24 (+36 more)

### Community 5 - "main.dart"
Cohesion: 0.22
Nodes (8): android, DefaultFirebaseOptions, ios, macos, web, windows, package:firebase_core/firebase_core.dart, static const FirebaseOptions

### Community 6 - "app_colors.dart"
Cohesion: 0.08
Nodes (24): AppColors, background, border, divider, error, errorBackground, info, infoBackground (+16 more)

### Community 7 - "add_item_form.dart"
Cohesion: 0.05
Nodes (38): ../../data/models/warehouse_return_draft.dart, int?, condition, itemCode, itemName, notes, originalVoucherNumber, quantity (+30 more)

### Community 8 - "DashboardCubit"
Cohesion: 0.27
Nodes (11): DashboardCubit, DashboardFailure, DashboardInitial, DashboardLoading, DashboardState, DashboardSuccess, items, message (+3 more)

### Community 9 - "transaction_model.dart"
Cohesion: 0.14
Nodes (13): CollectionReference, ../../../../core/constants/firestore_collections.dart, FirebaseFirestore, items_repository_base.dart, items_repository_failure.dart, addItem, _firebaseAuth, _firestore (+5 more)

### Community 10 - "transactions_cubit.dart"
Cohesion: 0.05
Nodes (40): ../data/repositories/transactions_repository_base.dart, _allLogs, _applyFilterAndQuery, close, createAdjustmentTransaction, createInboundTransaction, createOutboundTransaction, _currentFilter (+32 more)

### Community 11 - "item_model.dart"
Cohesion: 0.18
Nodes (11): ../../../../core/constants/app_routes.dart, build, _UiOnlyNotice, WarehouseReturnScreen, build, StockAdjustmentScreen, package:go_router/go_router.dart, AppRoutes.newMovement (+3 more)

### Community 12 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.13
Nodes (21): ../../../../core/shared_widgets/custom_button.dart, Cubit, ../../cubit/items_cubit.dart, ../../cubit/items_state.dart, ItemsCubit, ItemsFailure, ItemsInitial, ItemsLoading (+13 more)

### Community 13 - "pdf_voucher_dialog.dart"
Cohesion: 0.14
Nodes (13): build, _buildRow, date, deliveredBy, driverName, itemName, partyName, PdfVoucherDialog (+5 more)

### Community 14 - "adjustment_form.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اظهر المرتجع والجرد في ابسط صورة للتحكم والتنقل, Source Nodes

### Community 15 - "inbound_form.dart"
Cohesion: 0.17
Nodes (11): createState, _dateController, _deliveredByController, dispose, _driverNameController, _itemCodeController, _itemNameController, _quantityController (+3 more)

### Community 16 - "outbound_form.dart"
Cohesion: 0.17
Nodes (11): createState, _dateController, _dispatchedByController, dispose, _driverNameController, _itemCodeController, _itemNameController, _quantityController (+3 more)

### Community 17 - "stock_summary_card.dart"
Cohesion: 0.25
Nodes (7): build, description, isLast, number, ReturnWorkflowCard, title, _WorkflowStep

### Community 18 - "dashboard_repository.dart"
Cohesion: 0.15
Nodes (12): Key, build, buttonKey, color, icon, onStocktakeTap, onTap, onWarehouseReturnTap (+4 more)

### Community 19 - "custom_text_field.dart"
Cohesion: 0.05
Nodes (36): FocusNode?, Iterable, autofillHints, build, controller, CustomTextField, enabled, focusNode (+28 more)

### Community 20 - "transactions_repository.dart"
Cohesion: 0.22
Nodes (8): ../../../../core/shared_widgets/pdf_voucher_dialog.dart, ../../../../core/shared_widgets/status_badge.dart, TransactionModel, build, _buildBadge, _showPdfDialog, transaction, TransactionListItem

### Community 21 - "package:flutter/material.dart"
Cohesion: 0.18
Nodes (10): ../constants/app_colors.dart, ../constants/app_sizes.dart, build, _buildNavItem, currentRoute, _isSecondaryMovementRoute, onLogout, TabletNavigationRail (+2 more)

### Community 22 - "status_badge.dart"
Cohesion: 0.22
Nodes (8): adjustment, backgroundColor, build, inbound, label, outbound, StatusBadge, textColor

### Community 23 - "custom_button.dart"
Cohesion: 0.22
Nodes (8): Color, backgroundColor, build, CustomButton, icon, isLoading, onPressed, text

### Community 24 - "transaction_list_item.dart"
Cohesion: 0.07
Nodes (27): ../../../dashboard/cubit/dashboard_cubit.dart, ../../../dashboard/cubit/dashboard_state.dart, _changeMovementKind, createState, _itemCountLabel, _lines, _movementKind, NewMovementScreen (+19 more)

### Community 25 - "app_routes.dart"
Cohesion: 0.10
Nodes (18): addItem, AppRoutes, dashboard, inboundEntry, login, newMovement, outboundEntry, stockAdjustment (+10 more)

### Community 26 - "tablet_navigation_rail.dart"
Cohesion: 0.22
Nodes (8): ../constants/app_routes.dart, ../constants/app_strings.dart, build, currentRoute, _isSecondaryMovementRoute, onLogout, WorkerBottomNavigation, VoidCallback

### Community 27 - "custom_app_bar.dart"
Cohesion: 0.20
Nodes (9): ../constants/app_text_styles.dart, actions, build, CustomAppBar, leading, preferredSize, title, PreferredSizeWidget (+1 more)

### Community 28 - "package:flutter/material.dart"
Cohesion: 0.17
Nodes (12): ../../../../core/constants/app_sizes.dart, core/constants/app_strings.dart, ../../../../core/shared_widgets/custom_app_bar.dart, AddItemScreen, build, build, InboundEntryScreen, build (+4 more)

### Community 29 - "transactions_state.dart"
Cohesion: 0.22
Nodes (14): build, TransactionsCubit, message, selectedFilter, transactions, TransactionsFailure, TransactionsInitial, TransactionsLoading (+6 more)

### Community 30 - "TransactionsCubit"
Cohesion: 0.12
Nodes (15): app_routes.dart, ../../features/auth/cubit/login/login_cubit.dart, ../../features/auth/data/repositories/auth_repository.dart, ../../features/auth/presentation/routing/auth_session_notifier.dart, ../../features/auth/presentation/screens/login_screen.dart, ../../features/dashboard/presentation/screens/dashboard_screen.dart, ../../features/items/presentation/screens/add_item_screen.dart, ../../features/returns/presentation/screens/warehouse_return_screen.dart (+7 more)

### Community 31 - "Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها, Source Nodes

### Community 32 - "Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك, Source Nodes

### Community 33 - "item_quantity_sheet.dart"
Cohesion: 0.08
Nodes (25): build, _cartons, _changeCartons, _changePieces, createState, _exceedsAvailableStock, _hasQuantity, icon (+17 more)

### Community 34 - "movement_ui_types.dart"
Cohesion: 0.06
Nodes (34): int get, active, code, copyWith, currentStockBalance, currentStockPieces, fromMap, id (+26 more)

### Community 35 - "items_cubit.dart"
Cohesion: 0.11
Nodes (23): ../../cubit/login/login_cubit.dart, ../../cubit/login/login_state.dart, FormState, AppRouter, LoginCubit, LoginFailure, LoginInitial, LoginState (+15 more)

### Community 36 - "../../../../core/models/inventory_item.dart"
Cohesion: 0.22
Nodes (8): ../../../../core/models/inventory_item.dart, dashboard_repository_base.dart, ../../../items/data/repositories/items_repository_base.dart, DashboardRepositoryBase, watchItems, DashboardRepository, _itemsRepository, watchItems

### Community 37 - "movement_type_selector.dart"
Cohesion: 0.17
Nodes (11): backgroundColor, build, color, icon, label, onChanged, onTap, selected (+3 more)

### Community 38 - "current_voucher_panel.dart"
Cohesion: 0.14
Nodes (15): build, CurrentVoucherPanel, _EmptyVoucherState, _itemCountLabel, line, lines, movementKind, onContinue (+7 more)

### Community 39 - "movement_voucher_preview_dialog.dart"
Cohesion: 0.18
Nodes (10): MovementKind, MovementVoucherDetails, build, _DetailChip, details, label, lines, movementKind (+2 more)

### Community 40 - "selectable_item_card.dart"
Cohesion: 0.22
Nodes (8): InventoryItem, MovementLineViewData, build, item, onTap, SelectableItemCard, selectedLine, movement_ui_types.dart

### Community 41 - "../../../../core/constants/app_colors.dart"
Cohesion: 0.20
Nodes (9): ../../../../core/constants/app_colors.dart, ../../../../core/constants/app_text_styles.dart, build, _buildItemCard, StockItemsList, build, _buildStatItem, StockSummaryCard (+1 more)

### Community 42 - "Q: اضافه اسم السائق في الاستلام والتسليم"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اضافه اسم السائق في الاستلام والتسليم, Source Nodes

### Community 43 - "Q: العميل عاوز يبسط الامور جدا بحيث العامل يفتخ السيستم لما يجي يدوس علي منتج يطلعلو عاوز كام منو هياخد ولا هيخصم منو وبناء علي طلبو هيتحمع في الفاتوره عاوزها مبسطه خالص اقترحلي ال UI"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: العميل عاوز يبسط الامور جدا بحيث العامل يفتخ السيستم لما يجي يدوس علي منتج يطلعلو عاوز كام منو هياخد ولا هيخصم منو وبناء علي طلبو هيتحمع في الفاتوره عاوزها مبسطه خالص اقترحلي ال UI, Source Nodes

### Community 44 - "Q: اعمل الخطه ك ui. بس"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اعمل الخطه ك ui. بس, Source Nodes

### Community 45 - "login_screen.dart"
Cohesion: 0.13
Nodes (14): ../constants/app_router.dart, ../../features/auth/data/repositories/firebase_auth_repository.dart, ../../features/dashboard/data/repositories/dashboard_repository_base.dart, ../../features/dashboard/data/repositories/dashboard_repository.dart, ../../features/items/data/repositories/items_repository_base.dart, ../../features/items/data/repositories/items_repository.dart, ../../features/transactions/data/repositories/transactions_repository_base.dart, ../../features/transactions/data/repositories/transactions_repository.dart (+6 more)

### Community 46 - "item_model.dart"
Cohesion: 0.20
Nodes (9): IconData, build, _buildActionButton, color, icon, _QuickAction, QuickActionBar, route (+1 more)

### Community 47 - "transaction_list_item.dart"
Cohesion: 0.15
Nodes (12): core/di/service_locator.dart, core/theme/app_theme.dart, features/dashboard/cubit/dashboard_cubit.dart, features/items/cubit/items_cubit.dart, features/transactions/cubit/transactions_cubit.dart, GoRouter, build, configureDependencies (+4 more)

### Community 48 - "firebase_auth_repository.dart"
Cohesion: 0.18
Nodes (10): auth_failure.dart, auth_repository.dart, FirebaseAuth, _firebaseAuth, isSignedIn, _mapFirebaseFailure, signInWithEmailAndPassword, signOut (+2 more)

### Community 49 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.29
Nodes (6): ../data/repositories/items_repository_base.dart, ../data/repositories/items_repository_failure.dart, items_state.dart, _repository, submitNewItem, package:flutter_bloc/flutter_bloc.dart

### Community 50 - "Q: نفذ خطة UI المبسطة للحركة متعددة الأصناف فقط"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: نفذ خطة UI المبسطة للحركة متعددة الأصناف فقط, Source Nodes

### Community 51 - "Q: بعد الضغط على الاستكمال والمعاينة والطباعة هل يطبع ويخصم للمنصرف أو يزيد للوارد ثم يفرغ الأصناف المختارة؟"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: بعد الضغط على الاستكمال والمعاينة والطباعة هل يطبع ويخصم للمنصرف أو يزيد للوارد ثم يفرغ الأصناف المختارة؟, Source Nodes

### Community 52 - "Q: عاوز يكون في حاجه للمرتجع وحاجه لجرد المخزن"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: عاوز يكون في حاجه للمرتجع وحاجه لجرد المخزن, Source Nodes

### Community 53 - "adjustment_form.dart"
Cohesion: 0.20
Nodes (10): _actualCountController, AdjustmentForm, _AdjustmentFormState, createState, dispose, _isSubmitting, _itemCodeController, _itemNameController (+2 more)

### Community 54 - "../constants/app_colors.dart"
Cohesion: 0.25
Nodes (7): bool get, AuthRepository, isSignedIn, signInWithEmailAndPassword, signOut, watchAuthentication, FirebaseAuthRepository

### Community 55 - "../../../dashboard/data/models/item_model.dart"
Cohesion: 0.40
Nodes (4): addItem, ItemsRepositoryBase, watchActiveItems, ItemsRepository

### Community 56 - "responsive_layout.dart"
Cohesion: 0.25
Nodes (7): build, isMobile, isTablet, mobileLayout, ResponsiveLayout, tabletLayout, Widget

### Community 57 - "dashboard_screen.dart"
Cohesion: 0.25
Nodes (8): ../../cubit/dashboard_cubit.dart, ../../cubit/dashboard_state.dart, createState, DashboardScreen, _DashboardScreenState, initState, ../widgets/stock_items_list.dart, ../widgets/stock_summary_card.dart

### Community 58 - "auth_failure.dart"
Cohesion: 0.22
Nodes (7): Exception, AuthFailure, message, toString, ItemsRepositoryFailure, message, toString

### Community 59 - "Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه, Source Nodes

### Community 60 - "auth_session_notifier.dart"
Cohesion: 0.25
Nodes (7): ChangeNotifier, dart:async, AuthSessionNotifier, dispose, _subscription, package:flutter/foundation.dart, StreamSubscription

### Community 61 - "stock_summary_model.dart"
Cohesion: 0.25
Nodes (7): fromJson, lowStockItemsCount, StockSummaryModel, toJson, totalInboundCount, totalItemsCount, totalOutboundCount

### Community 62 - "State"
Cohesion: 0.32
Nodes (8): WarehouseReturnForm, _WarehouseReturnFormState, InboundForm, _InboundFormState, OutboundForm, _OutboundFormState, State, StatefulWidget

### Community 63 - "login_cubit.dart"
Cohesion: 0.29
Nodes (6): ../../data/repositories/auth_failure.dart, ../../data/repositories/auth_repository.dart, _authRepository, _isValidEmail, signIn, login_state.dart

### Community 64 - "build"
Cohesion: 0.67
Nodes (3): build, AppRoutes.stockAdjustment, AppRoutes.warehouseReturn

## Knowledge Gaps
- **574 isolated node(s):** `AppColors`, `primary`, `primaryLight`, `primaryDark`, `secondary` (+569 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Work-memory lessons

**Preferred sources** — corroborated by past sessions; start here.
- `TransactionsCubit` (5× useful, score=4.928170249)
- `NewMovementScreen` (4× useful, score=3.963032528) _(code changed — re-verify)_
- `StockAdjustmentScreen` (3× useful, score=2.996163982)
- `TransactionModel` (3× useful, score=2.964183792)
- `WarehouseReturnDraft` (3× useful, score=2.963120731)
- `WarehouseReturnScreen` (3× useful, score=2.962955238)
- `PdfVoucherDialog` (3× useful, score=2.930612136)
- `WarehouseReturnForm` (2× useful, score=1.997438148)
- `AdjustmentForm` (2× useful, score=1.997438148)
- `DashboardRepository` (2× useful, score=1.981915442) _(code changed — re-verify)_

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `TransactionsCubit` connect `transactions_state.dart` to `TransactionsCubit`, `transactions_cubit.dart`, `package:flutter_bloc/flutter_bloc.dart`, `login_screen.dart`, `inbound_form.dart`, `outbound_form.dart`, `transaction_list_item.dart`, `adjustment_form.dart`, `State`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **Why does `DashboardCubit` connect `DashboardCubit` to `StatelessWidget`, `../../../../core/constants/app_colors.dart`, `package:flutter_bloc/flutter_bloc.dart`, `login_screen.dart`, `transaction_list_item.dart`, `transaction_list_item.dart`, `dashboard_screen.dart`, `transactions_state.dart`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **What connects `AppColors`, `primary`, `primaryLight` to the rest of the system?**
  _574 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_strings.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.025 - nodes in this community are weakly interconnected._
- **Should `StatelessWidget` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._
- **Should `app_sizes.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.043478260869565216 - nodes in this community are weakly interconnected._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._