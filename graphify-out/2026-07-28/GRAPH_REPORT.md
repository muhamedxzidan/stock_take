# Graph Report - stock_take  (2026-07-28)

## Corpus Check
- 112 files · ~26,271 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1424 nodes · 2126 edges · 96 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `ed5eb782`
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
- inventory_item_selector_field.dart
- dashboard_cubit.dart
- inventory_number_parsing.dart
- package:go_router/go_router.dart
- StatelessWidget
- return_resolution.dart
- transaction_filter_bar.dart
- _NewMovementScreenState
- inbound_entry_screen.dart
- warehouse_return_screen.dart
- inventory_number_parsing.dart
- CartonPieceQuantity
- AppRoutes.transactionHistory
- main.dart
- StatelessWidget
- outbound_entry_screen.dart
- start_stocktake_card.dart
- stocktake_session.dart
- transaction_history_screen.dart
- stocktake_line.dart
- movement_report_summary.dart
- add_item_form.dart
- stocktake_repository_base.dart
- tablet_navigation_rail.dart
- dashboard_screen.dart
- ../../../../core/constants/app_colors.dart
- package:go_router/go_router.dart
- build
- stock_summary_model.dart
- item_catalog_cubit.dart
- ItemsRepositoryBase

## God Nodes (most connected - your core abstractions)
1. `TransactionsCubit` - 24 edges
2. `ItemCatalogCubit` - 23 edges
3. `ReturnResolutionCubit` - 18 edges
4. `MovementHistoryCubit` - 17 edges
5. `StocktakeCubit` - 15 edges
6. `DashboardCubit` - 14 edges
7. `LoginCubit` - 12 edges
8. `ItemsCubit` - 12 edges
9. `ReturnsCubit` - 12 edges
10. `InventoryItem` - 10 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `DashboardCubit`  [EXTRACTED]
  lib/features/dashboard/presentation/screens/dashboard_screen.dart → lib/features/dashboard/cubit/dashboard_cubit.dart
- `initState` --references--> `ItemCatalogCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/inbound_entry_screen.dart → lib/features/items/cubit/item_catalog_cubit.dart
- `initState` --references--> `ItemCatalogCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/outbound_entry_screen.dart → lib/features/items/cubit/item_catalog_cubit.dart
- `initState` --references--> `StocktakeCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/stock_adjustment_screen.dart → lib/features/stocktake/cubit/stocktake_cubit.dart
- `_confirm` --references--> `TransactionsCubit`  [EXTRACTED]
  lib/features/transactions/presentation/widgets/movement_voucher_preview_dialog.dart → lib/features/transactions/cubit/transactions_cubit.dart

## Import Cycles
- None detected.

## Communities (96 total, 0 thin omitted)

### Community 0 - "app_strings.dart"
Cohesion: 0.03
Nodes (74): actualCount, addItemTitle, adjustmentReason, adjustmentTitle, AppStrings, appTitle, authorizedUsersOnly, backToNewMovement (+66 more)

### Community 1 - "StatelessWidget"
Cohesion: 0.08
Nodes (25): createCustomerReturn, resolveReturn, ReturnsRepositoryBase, watchPendingReturns, _counters, createCustomerReturn, _customerReturnCounterId, _firebaseAuth (+17 more)

### Community 2 - "app_router.dart"
Cohesion: 0.12
Nodes (17): ../constants/app_routes.dart, ../constants/app_strings.dart, GoRouterState, build, child, _confirmLogout, MainShellScreen, state (+9 more)

### Community 3 - "TransactionsCubit"
Cohesion: 0.15
Nodes (16): ../../data/models/movement_record.dart, ../../data/models/movement_report_summary.dart, dateFilterMode, dateFrom, dateTo, message, MovementDateFilterMode, MovementHistoryFailure (+8 more)

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
Cohesion: 0.08
Nodes (31): Cubit, ../../cubit/returns_cubit.dart, ../../cubit/returns_state.dart, ../../data/models/warehouse_return_draft.dart, ../data/repositories/returns_repository_base.dart, ../data/repositories/returns_repository_failure.dart, ../../../items/presentation/widgets/inventory_item_selector_field.dart, createCustomerReturn (+23 more)

### Community 8 - "DashboardCubit"
Cohesion: 0.36
Nodes (9): DashboardCubit, DashboardFailure, DashboardInitial, DashboardLoading, DashboardState, DashboardSuccess, items, message (+1 more)

### Community 9 - "transaction_model.dart"
Cohesion: 0.12
Nodes (16): CollectionReference, ../../../../core/constants/firestore_collections.dart, FirebaseFirestore, items_repository_base.dart, items_repository_failure.dart, addItem, _counters, _firebaseAuth (+8 more)

### Community 10 - "transactions_cubit.dart"
Cohesion: 0.12
Nodes (16): actorName, date, fromJson, id, itemCode, itemId, itemName, notes (+8 more)

### Community 11 - "item_model.dart"
Cohesion: 0.10
Nodes (20): ../data/repositories/transactions_repository_base.dart, ../data/repositories/transactions_repository_failure.dart, _allLogs, _applyFilterAndQuery, close, createAdjustmentTransaction, createInboundMovement, createInboundTransaction (+12 more)

### Community 12 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.11
Nodes (17): actionLabel, cartons, date, deliveredBy, driverName, item, label, MovementVoucherDetails (+9 more)

### Community 13 - "pdf_voucher_dialog.dart"
Cohesion: 0.14
Nodes (13): build, _buildRow, date, deliveredBy, driverName, itemName, partyName, PdfVoucherDialog (+5 more)

### Community 14 - "adjustment_form.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اظهر المرتجع والجرد في ابسط صورة للتحكم والتنقل, Source Nodes

### Community 15 - "inbound_form.dart"
Cohesion: 0.15
Nodes (12): ../../../../core/shared_widgets/pdf_voucher_dialog.dart, createState, _dateController, _deliveredByController, dispose, _driverNameController, _quantity, _receivedByController (+4 more)

### Community 16 - "outbound_form.dart"
Cohesion: 0.17
Nodes (11): createState, _dateController, _dispatchedByController, dispose, _driverNameController, _quantity, _receivedByController, _recipientController (+3 more)

### Community 17 - "stock_summary_card.dart"
Cohesion: 0.29
Nodes (6): ../../../../core/constants/app_text_styles.dart, ../../data/models/stock_summary_model.dart, build, _buildStatItem, StockSummaryCard, summary

### Community 18 - "dashboard_repository.dart"
Cohesion: 0.15
Nodes (12): Key, build, buttonKey, color, icon, onStocktakeTap, onTap, onWarehouseReturnTap (+4 more)

### Community 19 - "custom_text_field.dart"
Cohesion: 0.09
Nodes (21): FocusNode?, Iterable, autofillHints, build, controller, enabled, fieldKey, focusNode (+13 more)

### Community 20 - "transactions_repository.dart"
Cohesion: 0.08
Nodes (24): arabicLabel, counterId, _counters, createInboundMovement, _createInventoryMovement, createOutboundMovement, createTransaction, fetchTransactions (+16 more)

### Community 21 - "package:flutter/material.dart"
Cohesion: 0.13
Nodes (15): build, _continue, createState, _dateController, _deliveredByController, dispose, _driverController, initState (+7 more)

### Community 22 - "status_badge.dart"
Cohesion: 0.14
Nodes (13): MovementRecord, build, _formatDate, _itemsLabel, label, movement, _quantityLabel, _showDetails (+5 more)

### Community 23 - "custom_button.dart"
Cohesion: 0.08
Nodes (25): _adjustmentCounterId, completeStocktake, _counters, fetchOpenStocktake, _firebaseAuth, _firestore, _items, _mapLine (+17 more)

### Community 24 - "transaction_list_item.dart"
Cohesion: 0.08
Nodes (26): ../../../items/cubit/item_catalog_state.dart, _changeMovementKind, createState, _itemCountLabel, _lines, _movementKind, NewMovementScreen, _NewMovementScreenState (+18 more)

### Community 25 - "app_routes.dart"
Cohesion: 0.10
Nodes (18): addItem, AppRoutes, dashboard, inboundEntry, login, newMovement, outboundEntry, stockAdjustment (+10 more)

### Community 26 - "tablet_navigation_rail.dart"
Cohesion: 0.13
Nodes (14): ../../../../core/models/carton_piece_quantity.dart, int get, build, _cartons, createState, _exceedsAvailableStock, _hasQuantity, initialSelection (+6 more)

### Community 27 - "custom_app_bar.dart"
Cohesion: 0.20
Nodes (9): Color, adjustment, backgroundColor, build, inbound, label, outbound, StatusBadge (+1 more)

### Community 28 - "package:flutter/material.dart"
Cohesion: 0.18
Nodes (10): createInboundMovement, createOutboundMovement, createTransaction, fetchTransactions, TransactionsRepositoryBase, watchMovements, TransactionsRepository, ../models/inventory_movement.dart (+2 more)

### Community 29 - "transactions_state.dart"
Cohesion: 0.15
Nodes (22): ../../data/models/inventory_movement.dart, ../data/models/transaction_model.dart, build, TransactionsCubit, InventoryMovementFailure, InventoryMovementSaved, InventoryMovementSaving, message (+14 more)

### Community 30 - "TransactionsCubit"
Cohesion: 0.11
Nodes (18): ../constants/app_router.dart, ../../features/auth/data/repositories/firebase_auth_repository.dart, ../../features/dashboard/data/repositories/dashboard_repository_base.dart, ../../features/dashboard/data/repositories/dashboard_repository.dart, ../../features/items/data/repositories/items_repository_base.dart, ../../features/items/data/repositories/items_repository.dart, ../../features/returns/data/repositories/returns_repository_base.dart, ../../features/returns/data/repositories/returns_repository.dart (+10 more)

### Community 31 - "Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها, Source Nodes

### Community 32 - "Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك, Source Nodes

### Community 33 - "item_quantity_sheet.dart"
Cohesion: 0.08
Nodes (25): ../../../../core/extensions/inventory_number_parsing.dart, affectedPieces, businessAt, cartons, deliveredBy, driverName, id, itemCode (+17 more)

### Community 34 - "movement_ui_types.dart"
Cohesion: 0.10
Nodes (20): _actualQuantity, build, countedItems, createState, _formatDate, initState, isCompleting, isSaving (+12 more)

### Community 35 - "items_cubit.dart"
Cohesion: 0.11
Nodes (24): ../../../../core/shared_widgets/custom_button.dart, ../../cubit/login/login_cubit.dart, ../../cubit/login/login_state.dart, FormState, AppRouter, LoginCubit, LoginFailure, LoginInitial (+16 more)

### Community 36 - "../../../../core/models/inventory_item.dart"
Cohesion: 0.10
Nodes (19): _allMovements, close, _dateFilterMode, _dateFrom, _dateTo, _emitFilteredMovements, filterByType, loadMovements (+11 more)

### Community 37 - "movement_type_selector.dart"
Cohesion: 0.15
Nodes (12): backgroundColor, build, color, icon, label, _MovementTypeButton, MovementTypeSelector, onChanged (+4 more)

### Community 38 - "current_voucher_panel.dart"
Cohesion: 0.15
Nodes (12): build, CurrentVoucherPanel, _EmptyVoucherState, _itemCountLabel, line, lines, movementKind, onContinue (+4 more)

### Community 39 - "movement_voucher_preview_dialog.dart"
Cohesion: 0.10
Nodes (19): carton_piece_quantity.dart, active, code, copyWith, currentStockBalance, currentStockPieces, fromMap, id (+11 more)

### Community 40 - "selectable_item_card.dart"
Cohesion: 0.22
Nodes (8): InventoryItem, MovementLineViewData, build, item, onTap, SelectableItemCard, selectedLine, movement_ui_types.dart

### Community 41 - "../../../../core/constants/app_colors.dart"
Cohesion: 0.14
Nodes (13): int?, id, itemCode, itemId, itemName, itemsPerCarton, quantityPieces, receivedAt (+5 more)

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
Nodes (15): class, InventoryMovementDraft, build, _confirm, createState, _DetailChip, details, _isSaving (+7 more)

### Community 46 - "item_model.dart"
Cohesion: 0.20
Nodes (9): ../../../../core/constants/app_routes.dart, build, _buildActionButton, color, icon, _QuickAction, QuickActionBar, route (+1 more)

### Community 47 - "transaction_list_item.dart"
Cohesion: 0.17
Nodes (11): ../constants/app_colors.dart, ../constants/app_text_styles.dart, actions, build, leading, preferredSize, title, AppTheme (+3 more)

### Community 48 - "firebase_auth_repository.dart"
Cohesion: 0.11
Nodes (17): auth_failure.dart, auth_repository.dart, bool get, FirebaseAuth, AuthRepository, isSignedIn, signInWithEmailAndPassword, signOut (+9 more)

### Community 49 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.29
Nodes (6): ../data/models/new_inventory_item_draft.dart, ../data/repositories/items_repository_base.dart, ../data/repositories/items_repository_failure.dart, items_state.dart, _repository, submitNewItem

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
Cohesion: 0.22
Nodes (8): ../../cubit/transactions_cubit.dart, ../../cubit/transactions_state.dart, _actualQuantity, createState, dispose, _isSubmitting, _reasonController, _selectedItem

### Community 54 - "../constants/app_colors.dart"
Cohesion: 0.05
Nodes (46): ../../cubit/return_resolution_state.dart, ../../data/models/return_resolution.dart, ../../data/models/warehouse_return_record.dart, close, loadPendingReturns, _pendingReturns, _repository, resolveReturn (+38 more)

### Community 55 - "../../../dashboard/data/models/item_model.dart"
Cohesion: 0.12
Nodes (16): custom_text_field.dart, ../extensions/inventory_number_parsing.dart, build, _cartonsController, createState, dispose, initialValue, initState (+8 more)

### Community 56 - "responsive_layout.dart"
Cohesion: 0.25
Nodes (7): build, isMobile, isTablet, mobileLayout, ResponsiveLayout, tabletLayout, Widget

### Community 57 - "dashboard_screen.dart"
Cohesion: 0.11
Nodes (18): businessDate, cartons, deliveredBy, driverName, InventoryMovementLine, itemCode, itemId, itemName (+10 more)

### Community 58 - "auth_failure.dart"
Cohesion: 0.10
Nodes (16): Exception, AuthFailure, message, toString, ItemsRepositoryFailure, message, toString, message (+8 more)

### Community 59 - "Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه, Source Nodes

### Community 60 - "auth_session_notifier.dart"
Cohesion: 0.25
Nodes (7): ChangeNotifier, ../../data/repositories/auth_repository.dart, AuthSessionNotifier, dispose, _subscription, package:flutter/foundation.dart, StreamSubscription

### Community 61 - "stock_summary_model.dart"
Cohesion: 0.18
Nodes (11): build, build, createState, initState, StockAdjustmentScreen, _StockAdjustmentScreenState, AppRoutes.newMovement, ../../../stocktake/cubit/stocktake_cubit.dart (+3 more)

### Community 62 - "State"
Cohesion: 0.50
Nodes (4): build, AppRoutes.addItem, AppRoutes.stockAdjustment, AppRoutes.warehouseReturn

### Community 63 - "login_cubit.dart"
Cohesion: 0.29
Nodes (6): ../../data/repositories/auth_failure.dart, _authRepository, _isValidEmail, signIn, login_state.dart, package:flutter_bloc/flutter_bloc.dart

### Community 64 - "build"
Cohesion: 0.40
Nodes (4): itemsPerCarton, name, NewInventoryItemDraft, openingStockPieces

### Community 65 - "inventory_item_selector_field.dart"
Cohesion: 0.14
Nodes (14): ../../cubit/item_catalog_cubit.dart, ../../cubit/item_catalog_state.dart, build, createState, _InventoryItemPickerSheet, _InventoryItemPickerSheetState, InventoryItemSelectorField, items (+6 more)

### Community 66 - "dashboard_cubit.dart"
Cohesion: 0.14
Nodes (13): dashboard_state.dart, ../data/repositories/dashboard_repository_base.dart, _allItems, _buildSummary, close, _debounceTimer, _emitFilteredItems, _itemsSubscription (+5 more)

### Community 67 - "inventory_number_parsing.dart"
Cohesion: 0.20
Nodes (14): CartonPieceQuantityFields, _CartonPieceQuantityFieldsState, _ReturnResolutionDialog, _ReturnResolutionDialogState, AdjustmentForm, _AdjustmentFormState, InboundForm, _InboundFormState (+6 more)

### Community 68 - "package:go_router/go_router.dart"
Cohesion: 0.42
Nodes (8): ItemsCubit, item, ItemsFailure, ItemsInitial, ItemsLoading, ItemsState, ItemsSuccess, message

### Community 69 - "StatelessWidget"
Cohesion: 0.18
Nodes (17): ../../data/models/stocktake_line.dart, StocktakeCubit, action, completion, itemId, lines, message, session (+9 more)

### Community 70 - "return_resolution.dart"
Cohesion: 0.18
Nodes (10): DateTime, itemCode, itemId, itemName, quantityPieces, receivedAt, returnId, returnNumber (+2 more)

### Community 71 - "transaction_filter_bar.dart"
Cohesion: 0.12
Nodes (15): app_routes.dart, ../../features/auth/cubit/login/login_cubit.dart, ../../features/auth/data/repositories/auth_repository.dart, ../../features/auth/presentation/routing/auth_session_notifier.dart, ../../features/auth/presentation/screens/login_screen.dart, ../../features/dashboard/presentation/screens/dashboard_screen.dart, ../../features/items/presentation/screens/add_item_screen.dart, ../../features/returns/presentation/screens/warehouse_return_screen.dart (+7 more)

### Community 72 - "_NewMovementScreenState"
Cohesion: 0.36
Nodes (9): ItemCatalogCubit, ItemCatalogFailure, ItemCatalogInitial, ItemCatalogLoading, ItemCatalogState, ItemCatalogSuccess, items, message (+1 more)

### Community 73 - "inbound_entry_screen.dart"
Cohesion: 0.29
Nodes (7): ../../../items/cubit/item_catalog_cubit.dart, build, createState, initState, OutboundEntryScreen, _OutboundEntryScreenState, ../widgets/outbound_form.dart

### Community 74 - "warehouse_return_screen.dart"
Cohesion: 0.25
Nodes (8): ../../cubit/return_resolution_cubit.dart, createState, initState, _ReturnPersistenceNotice, WarehouseReturnScreen, _WarehouseReturnScreenState, ../widgets/return_workflow_card.dart, ../widgets/warehouse_return_form.dart

### Community 75 - "inventory_number_parsing.dart"
Cohesion: 0.50
Nodes (3): InventoryNumberParsing, toInventoryInteger, String?

### Community 76 - "CartonPieceQuantity"
Cohesion: 0.33
Nodes (5): CartonPieceQuantity, cartons, fromTotalPieces, pieces, totalPiecesFor

### Community 77 - "AppRoutes.transactionHistory"
Cohesion: 0.22
Nodes (8): ../../../../core/models/inventory_item.dart, dashboard_repository_base.dart, ../../../items/data/repositories/items_repository_base.dart, DashboardRepositoryBase, watchItems, DashboardRepository, _itemsRepository, watchItems

### Community 78 - "main.dart"
Cohesion: 0.12
Nodes (16): core/di/service_locator.dart, core/theme/app_theme.dart, features/dashboard/cubit/dashboard_cubit.dart, features/items/cubit/item_catalog_cubit.dart, features/items/cubit/items_cubit.dart, features/returns/cubit/return_resolution_cubit.dart, features/returns/cubit/returns_cubit.dart, features/stocktake/cubit/stocktake_cubit.dart (+8 more)

### Community 79 - "StatelessWidget"
Cohesion: 0.17
Nodes (12): CustomAppBar, CustomTextField, _CountBadge, _PendingReturnTile, _SessionHeader, _ItemsPane, _MovementReportSummaryBar, _SummaryChip (+4 more)

### Community 80 - "outbound_entry_screen.dart"
Cohesion: 0.12
Nodes (15): ../../data/models/stocktake_session.dart, ../data/repositories/stocktake_repository_base.dart, ../data/repositories/stocktake_repository_failure.dart, close, completeStocktake, _isActing, _isLoading, _linesSubscription (+7 more)

### Community 81 - "start_stocktake_card.dart"
Cohesion: 0.12
Nodes (17): build, buttonKey, createState, date, _DateButton, dispose, _formatDate, initState (+9 more)

### Community 82 - "stocktake_session.dart"
Cohesion: 0.13
Nodes (14): adjustedItemCount, completedAt, id, movementVoucherNumber, netDifferencePieces, notes, periodFrom, periodTo (+6 more)

### Community 83 - "transaction_history_screen.dart"
Cohesion: 0.12
Nodes (20): MovementHistoryCubit, build, color, createState, _DateFilterBar, initState, label, onSelectRange (+12 more)

### Community 84 - "stocktake_line.dart"
Cohesion: 0.15
Nodes (12): actualQuantityPieces, copyWith, counted, countedAt, differencePieces, itemCodeSnapshot, itemId, itemNameSnapshot (+4 more)

### Community 85 - "movement_report_summary.dart"
Cohesion: 0.18
Nodes (10): customerReturnPieces, fromMovements, inboundPieces, movementCount, MovementReportSummary, outboundPieces, stocktakeAdjustmentNetPieces, supplierReplacementCount (+2 more)

### Community 86 - "add_item_form.dart"
Cohesion: 0.17
Nodes (12): ../../../../core/shared_widgets/carton_piece_quantity_fields.dart, ../../cubit/items_cubit.dart, ../../cubit/items_state.dart, AddItemForm, _AddItemFormState, build, createState, dispose (+4 more)

### Community 87 - "stocktake_repository_base.dart"
Cohesion: 0.20
Nodes (9): completeStocktake, fetchOpenStocktake, saveCount, startStocktake, StocktakeRepositoryBase, watchLines, StocktakeRepository, ../models/stocktake_line.dart (+1 more)

### Community 88 - "tablet_navigation_rail.dart"
Cohesion: 0.22
Nodes (8): ../constants/app_sizes.dart, build, _buildNavItem, currentRoute, _isSecondaryMovementRoute, onLogout, TabletNavigationRail, VoidCallback

### Community 89 - "dashboard_screen.dart"
Cohesion: 0.15
Nodes (14): core/constants/app_strings.dart, ../../../../core/shared_widgets/custom_text_field.dart, ../../cubit/dashboard_cubit.dart, ../../cubit/dashboard_state.dart, createState, DashboardScreen, _DashboardScreenState, initState (+6 more)

### Community 90 - "../../../../core/constants/app_colors.dart"
Cohesion: 0.29
Nodes (6): ../../../../core/constants/app_colors.dart, ../../cubit/movement_history_cubit.dart, ../../cubit/movement_history_state.dart, build, _buildFilterChip, TransactionFilterBar

### Community 91 - "package:go_router/go_router.dart"
Cohesion: 0.18
Nodes (11): ../../../../core/constants/app_sizes.dart, ../../../../core/shared_widgets/custom_app_bar.dart, AddItemScreen, build, build, createState, InboundEntryScreen, _InboundEntryScreenState (+3 more)

### Community 92 - "build"
Cohesion: 0.22
Nodes (8): IconData, backgroundColor, build, CustomButton, icon, isLoading, onPressed, text

### Community 93 - "stock_summary_model.dart"
Cohesion: 0.25
Nodes (7): fromJson, lowStockItemsCount, StockSummaryModel, toJson, totalInboundCount, totalItemsCount, totalOutboundCount

### Community 94 - "item_catalog_cubit.dart"
Cohesion: 0.29
Nodes (6): dart:async, item_catalog_state.dart, close, loadItems, _repository, _subscription

### Community 95 - "ItemsRepositoryBase"
Cohesion: 0.33
Nodes (5): addItem, ItemsRepositoryBase, watchActiveItems, ItemsRepository, ../models/new_inventory_item_draft.dart

## Knowledge Gaps
- **874 isolated node(s):** `AppColors`, `primary`, `primaryLight`, `primaryDark`, `secondary` (+869 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Work-memory lessons

**Preferred sources** — corroborated by past sessions; start here.
- `TransactionsCubit` (5× useful, score=4.928170249) _(code changed — re-verify)_
- `NewMovementScreen` (4× useful, score=3.963032528) _(code changed — re-verify)_
- `StockAdjustmentScreen` (3× useful, score=2.996163982) _(code changed — re-verify)_
- `TransactionModel` (3× useful, score=2.964183792)
- `WarehouseReturnDraft` (3× useful, score=2.963120731) _(code changed — re-verify)_
- `WarehouseReturnScreen` (3× useful, score=2.962955238) _(code changed — re-verify)_
- `PdfVoucherDialog` (3× useful, score=2.930612136)
- `WarehouseReturnForm` (2× useful, score=1.997438148) _(code changed — re-verify)_
- `AdjustmentForm` (2× useful, score=1.997438148) _(code changed — re-verify)_
- `DashboardRepository` (2× useful, score=1.981915442) _(code changed — re-verify)_

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `InventoryItem` connect `selectable_item_card.dart` to `inventory_item_selector_field.dart`, `package:go_router/go_router.dart`, `add_item_form.dart`, `movement_voucher_preview_dialog.dart`, `package:flutter_bloc/flutter_bloc.dart`, `inbound_form.dart`, `outbound_form.dart`, `adjustment_form.dart`, `tablet_navigation_rail.dart`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Why does `MovementHistoryCubit` connect `transaction_history_screen.dart` to `TransactionsCubit`, `../../../../core/models/inventory_item.dart`, `add_item_form.dart`, `main.dart`, `../../../../core/constants/app_colors.dart`, `TransactionsCubit`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Why does `StocktakeRepositoryBase` connect `stocktake_repository_base.dart` to `outbound_entry_screen.dart`, `TransactionsCubit`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **What connects `AppColors`, `primary`, `primaryLight` to the rest of the system?**
  _874 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_strings.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.02666666666666667 - nodes in this community are weakly interconnected._
- **Should `StatelessWidget` be split into smaller, more focused modules?**
  _Cohesion score 0.08262108262108261 - nodes in this community are weakly interconnected._
- **Should `app_router.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.11695906432748537 - nodes in this community are weakly interconnected._