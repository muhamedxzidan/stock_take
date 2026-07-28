# Graph Report - stock_take  (2026-07-28)

## Corpus Check
- 103 files · ~22,929 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1305 nodes · 1945 edges · 81 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5cd3f484`
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

## God Nodes (most connected - your core abstractions)
1. `ItemCatalogCubit` - 26 edges
2. `TransactionsCubit` - 24 edges
3. `ReturnResolutionCubit` - 18 edges
4. `MovementHistoryCubit` - 17 edges
5. `DashboardCubit` - 14 edges
6. `LoginCubit` - 12 edges
7. `ItemsCubit` - 12 edges
8. `ReturnsCubit` - 12 edges
9. `InventoryItem` - 10 edges
10. `TransactionsState` - 9 edges

## Surprising Connections (you probably didn't know these)
- `AppRouter` --references--> `LoginCubit`  [EXTRACTED]
  lib/core/constants/app_router.dart → lib/features/auth/cubit/login/login_cubit.dart
- `initState` --references--> `ItemCatalogCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/inbound_entry_screen.dart → lib/features/items/cubit/item_catalog_cubit.dart
- `initState` --references--> `ItemCatalogCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/outbound_entry_screen.dart → lib/features/items/cubit/item_catalog_cubit.dart
- `initState` --references--> `ItemCatalogCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/stock_adjustment_screen.dart → lib/features/items/cubit/item_catalog_cubit.dart
- `_confirm` --references--> `TransactionsCubit`  [EXTRACTED]
  lib/features/transactions/presentation/widgets/movement_voucher_preview_dialog.dart → lib/features/transactions/cubit/transactions_cubit.dart

## Import Cycles
- None detected.

## Communities (81 total, 0 thin omitted)

### Community 0 - "app_strings.dart"
Cohesion: 0.03
Nodes (78): actualCount, addItemTitle, adjustmentReason, adjustmentTitle, AppStrings, appTitle, authorizedUsersOnly, backToNewMovement (+70 more)

### Community 1 - "StatelessWidget"
Cohesion: 0.08
Nodes (25): createCustomerReturn, resolveReturn, ReturnsRepositoryBase, watchPendingReturns, _counters, createCustomerReturn, _customerReturnCounterId, _firebaseAuth (+17 more)

### Community 2 - "app_router.dart"
Cohesion: 0.12
Nodes (17): ../constants/app_routes.dart, ../constants/app_strings.dart, GoRouterState, build, child, _confirmLogout, MainShellScreen, state (+9 more)

### Community 3 - "TransactionsCubit"
Cohesion: 0.05
Nodes (47): ../../cubit/movement_history_cubit.dart, ../../cubit/movement_history_state.dart, ../../data/models/movement_record.dart, MovementHistoryCubit, dateFilterMode, dateFrom, dateTo, message (+39 more)

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
Cohesion: 0.06
Nodes (42): ../../cubit/returns_cubit.dart, ../../cubit/returns_state.dart, ../../data/models/warehouse_return_draft.dart, ../data/repositories/returns_repository_base.dart, ../data/repositories/returns_repository_failure.dart, createCustomerReturn, _isSaving, _repository (+34 more)

### Community 8 - "DashboardCubit"
Cohesion: 0.10
Nodes (25): ../../../../core/shared_widgets/custom_text_field.dart, ../../cubit/dashboard_cubit.dart, DashboardCubit, DashboardFailure, DashboardInitial, DashboardLoading, DashboardState, DashboardSuccess (+17 more)

### Community 9 - "transaction_model.dart"
Cohesion: 0.12
Nodes (16): CollectionReference, ../../../../core/constants/firestore_collections.dart, FirebaseFirestore, items_repository_base.dart, items_repository_failure.dart, addItem, _counters, _firebaseAuth (+8 more)

### Community 10 - "transactions_cubit.dart"
Cohesion: 0.11
Nodes (17): actorName, date, fromJson, id, itemCode, itemId, itemName, notes (+9 more)

### Community 11 - "item_model.dart"
Cohesion: 0.09
Nodes (21): ../data/models/transaction_model.dart, ../data/repositories/transactions_repository_base.dart, ../data/repositories/transactions_repository_failure.dart, _allLogs, _applyFilterAndQuery, close, createAdjustmentTransaction, createInboundMovement (+13 more)

### Community 12 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.06
Nodes (31): ../../../../core/models/inventory_item.dart, dashboard_repository_base.dart, ../../../items/data/repositories/items_repository_base.dart, DashboardRepositoryBase, watchItems, DashboardRepository, _itemsRepository, watchItems (+23 more)

### Community 13 - "pdf_voucher_dialog.dart"
Cohesion: 0.14
Nodes (13): build, _buildRow, date, deliveredBy, driverName, itemName, partyName, PdfVoucherDialog (+5 more)

### Community 14 - "adjustment_form.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اظهر المرتجع والجرد في ابسط صورة للتحكم والتنقل, Source Nodes

### Community 15 - "inbound_form.dart"
Cohesion: 0.15
Nodes (13): createState, _dateController, _deliveredByController, dispose, _driverNameController, InboundForm, _InboundFormState, _quantity (+5 more)

### Community 16 - "outbound_form.dart"
Cohesion: 0.14
Nodes (14): ../../../../core/shared_widgets/pdf_voucher_dialog.dart, createState, _dateController, _dispatchedByController, dispose, _driverNameController, OutboundForm, _OutboundFormState (+6 more)

### Community 17 - "stock_summary_card.dart"
Cohesion: 0.18
Nodes (10): ../../../../core/constants/app_colors.dart, ../../../../core/constants/app_text_styles.dart, ../../cubit/dashboard_state.dart, build, _buildItemCard, StockItemsList, build, _buildStatItem (+2 more)

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
Nodes (13): MovementRecord, build, _DetailText, _formatDate, _itemsLabel, label, movement, _quantityLabel (+5 more)

### Community 23 - "custom_button.dart"
Cohesion: 0.20
Nodes (9): Color, adjustment, backgroundColor, build, inbound, label, outbound, StatusBadge (+1 more)

### Community 24 - "transaction_list_item.dart"
Cohesion: 0.08
Nodes (24): ../../../items/cubit/item_catalog_state.dart, _changeMovementKind, createState, _itemCountLabel, _lines, _movementKind, onAddItem, onItemTap (+16 more)

### Community 25 - "app_routes.dart"
Cohesion: 0.18
Nodes (10): addItem, AppRoutes, dashboard, inboundEntry, login, newMovement, outboundEntry, stockAdjustment (+2 more)

### Community 26 - "tablet_navigation_rail.dart"
Cohesion: 0.14
Nodes (14): ../../../../core/models/carton_piece_quantity.dart, build, _cartons, createState, _exceedsAvailableStock, _hasQuantity, initialSelection, initState (+6 more)

### Community 27 - "custom_app_bar.dart"
Cohesion: 0.11
Nodes (19): ../constants/app_colors.dart, ../constants/app_sizes.dart, IconData, backgroundColor, build, CustomButton, icon, isLoading (+11 more)

### Community 28 - "package:flutter/material.dart"
Cohesion: 0.18
Nodes (10): createInboundMovement, createOutboundMovement, createTransaction, fetchTransactions, TransactionsRepositoryBase, watchMovements, TransactionsRepository, ../models/inventory_movement.dart (+2 more)

### Community 29 - "transactions_state.dart"
Cohesion: 0.26
Nodes (14): ../../data/models/inventory_movement.dart, TransactionsCubit, InventoryMovementFailure, InventoryMovementSaved, InventoryMovementSaving, message, movement, selectedFilter (+6 more)

### Community 30 - "TransactionsCubit"
Cohesion: 0.11
Nodes (18): ChangeNotifier, ../constants/app_router.dart, ../../features/auth/data/repositories/firebase_auth_repository.dart, ../../features/dashboard/data/repositories/dashboard_repository_base.dart, ../../features/dashboard/data/repositories/dashboard_repository.dart, ../../features/items/data/repositories/items_repository_base.dart, ../../features/items/data/repositories/items_repository.dart, ../../features/returns/data/repositories/returns_repository_base.dart (+10 more)

### Community 31 - "Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها, Source Nodes

### Community 32 - "Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: هيا المشروع ك ui ux بس وضيف كمان خاصيه المرتجع في المخزن ك ui بس برضو مفيش اي لوجيك لسه خليه بس جاهز للوجيك, Source Nodes

### Community 33 - "item_quantity_sheet.dart"
Cohesion: 0.07
Nodes (26): ../../../../core/extensions/inventory_number_parsing.dart, affectedPieces, businessAt, cartons, deliveredBy, driverName, id, itemCode (+18 more)

### Community 34 - "movement_ui_types.dart"
Cohesion: 0.20
Nodes (9): ../constants/app_text_styles.dart, actions, build, CustomAppBar, leading, preferredSize, title, PreferredSizeWidget (+1 more)

### Community 35 - "items_cubit.dart"
Cohesion: 0.11
Nodes (23): Cubit, ../../cubit/login/login_cubit.dart, ../../cubit/login/login_state.dart, FormState, LoginCubit, LoginFailure, LoginInitial, LoginState (+15 more)

### Community 36 - "../../../../core/models/inventory_item.dart"
Cohesion: 0.09
Nodes (21): ../../data/models/movement_report_summary.dart, _allMovements, close, _dateFilterMode, _dateFrom, _dateTo, _emitFilteredMovements, filterByType (+13 more)

### Community 37 - "movement_type_selector.dart"
Cohesion: 0.15
Nodes (12): backgroundColor, build, color, icon, label, _MovementTypeButton, MovementTypeSelector, onChanged (+4 more)

### Community 38 - "current_voucher_panel.dart"
Cohesion: 0.17
Nodes (11): build, CurrentVoucherPanel, _EmptyVoucherState, _itemCountLabel, line, lines, movementKind, onContinue (+3 more)

### Community 39 - "movement_voucher_preview_dialog.dart"
Cohesion: 0.05
Nodes (39): int get, active, code, copyWith, currentStockBalance, currentStockPieces, fromMap, id (+31 more)

### Community 40 - "selectable_item_card.dart"
Cohesion: 0.22
Nodes (8): InventoryItem, MovementLineViewData, build, item, onTap, SelectableItemCard, selectedLine, movement_ui_types.dart

### Community 41 - "../../../../core/constants/app_colors.dart"
Cohesion: 0.06
Nodes (35): DateTime, condition, itemCode, itemId, itemName, notes, originalVoucherNumber, quantityPieces (+27 more)

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
Nodes (15): class, ../../cubit/transactions_cubit.dart, build, _confirm, createState, _DetailChip, details, _isSaving (+7 more)

### Community 46 - "item_model.dart"
Cohesion: 0.20
Nodes (9): ../../../../core/constants/app_routes.dart, build, _buildActionButton, color, icon, _QuickAction, QuickActionBar, route (+1 more)

### Community 47 - "transaction_list_item.dart"
Cohesion: 0.22
Nodes (8): counters, FirestoreCollections, items, movements, returns, stocktakeLines, stocktakes, static const String

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
Cohesion: 0.18
Nodes (11): ../../../../core/shared_widgets/carton_piece_quantity_fields.dart, ../../cubit/transactions_state.dart, ../../../items/presentation/widgets/inventory_item_selector_field.dart, _actualQuantity, AdjustmentForm, _AdjustmentFormState, createState, dispose (+3 more)

### Community 54 - "../constants/app_colors.dart"
Cohesion: 0.12
Nodes (17): ../../cubit/return_resolution_state.dart, build, _conditionLabel, _confirm, count, _CountBadge, createState, dispose (+9 more)

### Community 55 - "../../../dashboard/data/models/item_model.dart"
Cohesion: 0.12
Nodes (16): custom_text_field.dart, ../extensions/inventory_number_parsing.dart, build, _cartonsController, createState, dispose, initialValue, initState (+8 more)

### Community 56 - "responsive_layout.dart"
Cohesion: 0.25
Nodes (7): build, isMobile, isTablet, mobileLayout, ResponsiveLayout, tabletLayout, Widget

### Community 57 - "dashboard_screen.dart"
Cohesion: 0.22
Nodes (15): ../../data/models/return_resolution.dart, ReturnResolutionCubit, message, pendingReturns, resolution, returnId, ReturnResolutionFailure, ReturnResolutionInitial (+7 more)

### Community 58 - "auth_failure.dart"
Cohesion: 0.12
Nodes (13): Exception, AuthFailure, message, toString, ItemsRepositoryFailure, message, toString, message (+5 more)

### Community 59 - "Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه, Source Nodes

### Community 60 - "auth_session_notifier.dart"
Cohesion: 0.17
Nodes (11): dart:async, ../../data/repositories/auth_repository.dart, item_catalog_state.dart, dispose, _subscription, close, loadItems, _repository (+3 more)

### Community 61 - "stock_summary_model.dart"
Cohesion: 0.22
Nodes (9): ../../../../core/constants/app_sizes.dart, core/constants/app_strings.dart, ../../../../core/shared_widgets/custom_app_bar.dart, AddItemScreen, build, createState, initState, ../widgets/add_item_form.dart (+1 more)

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
Cohesion: 0.15
Nodes (12): ../../cubit/item_catalog_cubit.dart, ../../cubit/item_catalog_state.dart, build, createState, InventoryItemSelectorField, items, label, onSelected (+4 more)

### Community 66 - "dashboard_cubit.dart"
Cohesion: 0.13
Nodes (14): dashboard_state.dart, ../../data/models/stock_summary_model.dart, ../data/repositories/dashboard_repository_base.dart, _allItems, _buildSummary, close, _debounceTimer, _emitFilteredItems (+6 more)

### Community 67 - "inventory_number_parsing.dart"
Cohesion: 0.27
Nodes (10): CartonPieceQuantityFields, _CartonPieceQuantityFieldsState, _InventoryItemPickerSheet, _InventoryItemPickerSheetState, NewMovementScreen, _NewMovementScreenState, StockAdjustmentScreen, _StockAdjustmentScreenState (+2 more)

### Community 68 - "package:go_router/go_router.dart"
Cohesion: 0.13
Nodes (21): ../../../../core/shared_widgets/custom_button.dart, ../../cubit/items_cubit.dart, ../../cubit/items_state.dart, ItemsCubit, item, ItemsFailure, ItemsInitial, ItemsLoading (+13 more)

### Community 69 - "StatelessWidget"
Cohesion: 0.20
Nodes (9): ../../data/models/warehouse_return_record.dart, close, loadPendingReturns, _pendingReturns, _repository, resolveReturn, _resolvingReturnId, _subscription (+1 more)

### Community 70 - "return_resolution.dart"
Cohesion: 0.22
Nodes (8): kind, movementId, returnId, returnNumber, ReturnResolutionDraft, ReturnResolutionKind, SavedReturnResolution, supplierName

### Community 71 - "transaction_filter_bar.dart"
Cohesion: 0.12
Nodes (16): app_routes.dart, ../../features/auth/cubit/login/login_cubit.dart, ../../features/auth/data/repositories/auth_repository.dart, ../../features/auth/presentation/routing/auth_session_notifier.dart, ../../features/auth/presentation/screens/login_screen.dart, ../../features/dashboard/presentation/screens/dashboard_screen.dart, ../../features/items/presentation/screens/add_item_screen.dart, ../../features/returns/presentation/screens/warehouse_return_screen.dart (+8 more)

### Community 72 - "_NewMovementScreenState"
Cohesion: 0.31
Nodes (10): ItemCatalogCubit, ItemCatalogFailure, ItemCatalogInitial, ItemCatalogLoading, ItemCatalogState, ItemCatalogSuccess, items, message (+2 more)

### Community 73 - "inbound_entry_screen.dart"
Cohesion: 0.29
Nodes (7): ../../../items/cubit/item_catalog_cubit.dart, build, createState, InboundEntryScreen, _InboundEntryScreenState, initState, ../widgets/inbound_form.dart

### Community 74 - "warehouse_return_screen.dart"
Cohesion: 0.18
Nodes (11): ../../cubit/return_resolution_cubit.dart, build, createState, initState, _ReturnPersistenceNotice, WarehouseReturnScreen, _WarehouseReturnScreenState, build (+3 more)

### Community 75 - "inventory_number_parsing.dart"
Cohesion: 0.50
Nodes (3): InventoryNumberParsing, toInventoryInteger, String?

### Community 76 - "CartonPieceQuantity"
Cohesion: 0.40
Nodes (4): CartonPieceQuantity, cartons, pieces, totalPiecesFor

### Community 77 - "AppRoutes.transactionHistory"
Cohesion: 0.40
Nodes (5): build, build, build, build, AppRoutes.transactionHistory

### Community 78 - "main.dart"
Cohesion: 0.12
Nodes (15): core/di/service_locator.dart, core/theme/app_theme.dart, features/dashboard/cubit/dashboard_cubit.dart, features/items/cubit/item_catalog_cubit.dart, features/items/cubit/items_cubit.dart, features/returns/cubit/return_resolution_cubit.dart, features/returns/cubit/returns_cubit.dart, features/transactions/cubit/movement_history_cubit.dart (+7 more)

### Community 79 - "StatelessWidget"
Cohesion: 0.18
Nodes (11): CustomTextField, _PendingReturnTile, _ResponsiveFieldRow, _ReturnConditionField, _ItemsPane, _DateFilterBar, _SummaryChip, _VoucherLineTile (+3 more)

### Community 80 - "outbound_entry_screen.dart"
Cohesion: 0.33
Nodes (6): build, createState, initState, OutboundEntryScreen, _OutboundEntryScreenState, ../widgets/outbound_form.dart

## Knowledge Gaps
- **799 isolated node(s):** `AppColors`, `primary`, `primaryLight`, `primaryDark`, `secondary` (+794 more)
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

- **Why does `TransactionsCubit` connect `transactions_state.dart` to `items_cubit.dart`, `package:go_router/go_router.dart`, `item_model.dart`, `AppRoutes.transactionHistory`, `login_screen.dart`, `inbound_form.dart`, `outbound_form.dart`, `main.dart`, `adjustment_form.dart`, `TransactionsCubit`?**
  _High betweenness centrality (0.045) - this node is a cross-community bridge._
- **Why does `TransactionType` connect `transactions_cubit.dart` to `item_model.dart`, `transactions_state.dart`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Why does `InventoryItem` connect `selectable_item_card.dart` to `inventory_item_selector_field.dart`, `package:go_router/go_router.dart`, `add_item_form.dart`, `movement_voucher_preview_dialog.dart`, `package:flutter_bloc/flutter_bloc.dart`, `inbound_form.dart`, `outbound_form.dart`, `adjustment_form.dart`, `tablet_navigation_rail.dart`?**
  _High betweenness centrality (0.030) - this node is a cross-community bridge._
- **What connects `AppColors`, `primary`, `primaryLight` to the rest of the system?**
  _799 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_strings.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.02531645569620253 - nodes in this community are weakly interconnected._
- **Should `StatelessWidget` be split into smaller, more focused modules?**
  _Cohesion score 0.08262108262108261 - nodes in this community are weakly interconnected._
- **Should `app_router.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.11695906432748537 - nodes in this community are weakly interconnected._