# Graph Report - stock_take  (2026-07-30)

## Corpus Check
- 130 files · ~31,031 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1623 nodes · 2341 edges · 115 communities (114 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2b05d14e`
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
- MovementHistoryCubit
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
- saved_printer.dart
- login_cubit.dart
- build
- inventory_item_selector_field.dart
- ItemsCubit
- inventory_number_parsing.dart
- package:go_router/go_router.dart
- StatelessWidget
- return_resolution.dart
- transaction_filter_bar.dart
- printer_connection_profile.dart
- add_item_form.dart
- warehouse_return_screen.dart
- LoginCubit
- CartonPieceQuantity
- AppRoutes.transactionHistory
- main.dart
- warehouse_return_draft.dart
- outbound_entry_screen.dart
- start_stocktake_card.dart
- stocktake_session.dart
- transaction_history_screen.dart
- firebase_options.dart
- movement_report_summary.dart
- responsive_layout.dart
- stocktake_repository_base.dart
- LoginCubit
- dashboard_screen.dart
- ../../../../core/constants/app_colors.dart
- responsive_layout.dart
- stock_summary_model.dart
- ../../../../core/constants/app_text_styles.dart
- item_catalog_cubit.dart
- dashboard_screen.dart
- ../../../../core/models/inventory_item.dart
- List
- bluetooth_printer_repository.dart
- thermal_receipt_content.dart
- dashboard_screen.dart
- Q: خطه عمل للمرتجع اللي هيتم رجوعه للمورد نفسه يعني مرتيح المخزن مظبوط وبيرجع للمخزن ك رصيد ازاي اعمل بقا مرتحع للمودر نفسه يعني ياخد بضاعه وتتسجب انها مرتحع للمودر وتنقص من رصيد مخزن هل هي موجوده بشكل تاني ؟
- firestore_collections.dart
- stock_summary_model.dart
- String?
- build
- Q: تشخيص فشل تسجيل الدخول الظاهر في Screenshot 2026-07-29
- AppRoutes.transactionHistory
- AuthSessionNotifier
- stock_balance_receipt_mapper.dart
- ../../../../core/models/inventory_item.dart
- Q: إضافة شعار EL SAUDI أعلى الريسيت وإجمالي الكراتين ثم القطع وتحسين وضوح الطباعة
- Q: خطة آمنة لتعديل وحذف الأصناف مع سجل تدقيق وطباعة الحركات وطباعة رصيد المخزن بالكامل
- PrinterRepositoryBase
- _NewMovementScreenState

## God Nodes (most connected - your core abstractions)
1. `ReturnResolutionCubit` - 18 edges
2. `TransactionsCubit` - 18 edges
3. `ItemCatalogCubit` - 17 edges
4. `PrinterCubit` - 17 edges
5. `MovementHistoryCubit` - 17 edges
6. `StocktakeCubit` - 16 edges
7. `DashboardCubit` - 15 edges
8. `LoginCubit` - 12 edges
9. `ItemsCubit` - 12 edges
10. `ReturnsCubit` - 12 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `DashboardCubit`  [EXTRACTED]
  lib/features/dashboard/presentation/screens/dashboard_screen.dart → lib/features/dashboard/cubit/dashboard_cubit.dart
- `_confirmCancellation` --references--> `StocktakeCubit`  [EXTRACTED]
  lib/features/transactions/presentation/screens/stock_adjustment_screen.dart → lib/features/stocktake/cubit/stocktake_cubit.dart
- `_confirm` --references--> `TransactionsCubit`  [EXTRACTED]
  lib/features/transactions/presentation/widgets/movement_voucher_preview_dialog.dart → lib/features/transactions/cubit/transactions_cubit.dart
- `AppRouter` --references--> `LoginCubit`  [EXTRACTED]
  lib/core/constants/app_router.dart → lib/features/auth/cubit/login/login_cubit.dart
- `_submit` --references--> `LoginCubit`  [EXTRACTED]
  lib/features/auth/presentation/screens/login_screen.dart → lib/features/auth/cubit/login/login_cubit.dart

## Import Cycles
- None detected.

## Communities (115 total, 1 thin omitted)

### Community 0 - "app_strings.dart"
Cohesion: 0.03
Nodes (70): actualCount, addItemTitle, adjustmentReason, adjustmentTitle, AppStrings, appTitle, authorizedUsersOnly, backToNewMovement (+62 more)

### Community 1 - "StatelessWidget"
Cohesion: 0.07
Nodes (31): DocumentReference, createCustomerReturn, resolveReturn, ReturnsRepositoryBase, watchPendingReturns, _counters, createCustomerReturn, _customerReturnCounterId (+23 more)

### Community 2 - "app_router.dart"
Cohesion: 0.11
Nodes (18): ../../../../core/models/thermal_receipt_data.dart, _formatDate, fromMovementRecord, fromSavedMovement, _movementLabel, MovementReceiptMapper, _partyLabel, createInboundMovement (+10 more)

### Community 3 - "TransactionsCubit"
Cohesion: 0.16
Nodes (15): ../../data/models/movement_report_summary.dart, dateFilterMode, dateFrom, dateTo, message, MovementDateFilterMode, MovementHistoryFailure, MovementHistoryInitial (+7 more)

### Community 4 - "app_sizes.dart"
Cohesion: 0.04
Nodes (44): app_colors.dart, AppSizes, buttonHeight, cardElevation, h12, h16, h20, h24 (+36 more)

### Community 5 - "main.dart"
Cohesion: 0.12
Nodes (17): custom_text_field.dart, build, CartonPieceQuantityFields, _CartonPieceQuantityFieldsState, _cartonsController, createState, dispose, initialValue (+9 more)

### Community 6 - "app_colors.dart"
Cohesion: 0.08
Nodes (24): AppColors, background, border, divider, error, errorBackground, info, infoBackground (+16 more)

### Community 7 - "add_item_form.dart"
Cohesion: 0.12
Nodes (16): actionLabel, cartons, date, deliveredBy, driverName, item, label, MovementVoucherDetails (+8 more)

### Community 8 - "DashboardCubit"
Cohesion: 0.12
Nodes (15): ../../cubit/return_resolution_state.dart, build, _confirm, count, _CountBadge, createState, dispose, _EmptyPendingReturns (+7 more)

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
Cohesion: 0.17
Nodes (11): ../../data/models/stocktake_line.dart, ../../data/models/stocktake_session.dart, action, completion, itemId, lines, message, session (+3 more)

### Community 13 - "pdf_voucher_dialog.dart"
Cohesion: 0.17
Nodes (11): build, build, _confirmCancellation, message, StockAdjustmentScreen, _StocktakeLoadFailure, AppRoutes.newMovement, ../../../stocktake/cubit/stocktake_cubit.dart (+3 more)

### Community 14 - "adjustment_form.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اظهر المرتجع والجرد في ابسط صورة للتحكم والتنقل, Source Nodes

### Community 15 - "inbound_form.dart"
Cohesion: 0.17
Nodes (12): ../../cubit/returns_cubit.dart, ../../cubit/returns_state.dart, ../../../items/presentation/widgets/inventory_item_selector_field.dart, build, createState, dispose, _quantity, _returnSourceController (+4 more)

### Community 16 - "outbound_form.dart"
Cohesion: 0.29
Nodes (6): ../../data/repositories/auth_failure.dart, _authRepository, _isValidEmail, signIn, login_state.dart, package:flutter_bloc/flutter_bloc.dart

### Community 17 - "stock_summary_card.dart"
Cohesion: 0.10
Nodes (24): Cubit, PrinterCubit, PrinterState, build, createState, _cubit, didChangeDependencies, dispose (+16 more)

### Community 18 - "dashboard_repository.dart"
Cohesion: 0.17
Nodes (11): build, buttonKey, color, icon, onStocktakeTap, onTap, onWarehouseReturnTap, _SecondaryOperationButton (+3 more)

### Community 19 - "custom_text_field.dart"
Cohesion: 0.09
Nodes (21): FocusNode?, Iterable, autofillHints, build, controller, enabled, fieldKey, focusNode (+13 more)

### Community 20 - "transactions_repository.dart"
Cohesion: 0.07
Nodes (29): arabicLabel, counterId, _counters, createInboundMovement, _createInventoryMovement, createOutboundMovement, createTransaction, _ensureInventoryIsUnlocked (+21 more)

### Community 21 - "package:flutter/material.dart"
Cohesion: 0.14
Nodes (14): build, _continue, createState, _dateController, _deliveredByController, dispose, _driverController, initState (+6 more)

### Community 22 - "status_badge.dart"
Cohesion: 0.12
Nodes (17): build, buttonKey, createState, date, _DateButton, dispose, _formatDate, initState (+9 more)

### Community 23 - "custom_button.dart"
Cohesion: 0.06
Nodes (30): _adjustmentCounterId, cancelStocktake, _claimLegacyOpenSession, completeStocktake, _counters, fetchOpenStocktake, _firebaseAuth, _firestore (+22 more)

### Community 24 - "transaction_list_item.dart"
Cohesion: 0.07
Nodes (28): ../../../items/cubit/item_catalog_state.dart, _changeMovementKind, createState, dispose, initialMovementKind, _itemCountLabel, _lines, _movementKind (+20 more)

### Community 25 - "app_routes.dart"
Cohesion: 0.18
Nodes (10): addItem, AppRoutes, dashboard, login, newInboundMovement, newMovement, newOutboundMovement, stockAdjustment (+2 more)

### Community 26 - "tablet_navigation_rail.dart"
Cohesion: 0.14
Nodes (14): build, _cartons, createState, _exceedsAvailableStock, _hasQuantity, initialSelection, initState, item (+6 more)

### Community 27 - "custom_app_bar.dart"
Cohesion: 0.20
Nodes (9): Color, adjustment, backgroundColor, build, inbound, label, outbound, StatusBadge (+1 more)

### Community 28 - "package:flutter/material.dart"
Cohesion: 0.11
Nodes (20): ../../../../core/constants/app_colors.dart, ../../cubit/printer_cubit.dart, ../../cubit/printer_state.dart, ThermalReceiptData, ThermalReceiptRasterizer, build, PrinterSetupButton, build (+12 more)

### Community 29 - "transactions_state.dart"
Cohesion: 0.29
Nodes (13): TransactionsCubit, InventoryMovementFailure, InventoryMovementSaved, InventoryMovementSaving, message, movement, selectedFilter, transactions (+5 more)

### Community 30 - "TransactionsCubit"
Cohesion: 0.09
Nodes (22): ChangeNotifier, ../constants/app_router.dart, ../../features/auth/data/repositories/firebase_auth_repository.dart, ../../features/dashboard/data/repositories/dashboard_repository_base.dart, ../../features/dashboard/data/repositories/dashboard_repository.dart, ../../features/items/data/repositories/items_repository_base.dart, ../../features/items/data/repositories/items_repository.dart, ../../features/printing/data/repositories/bluetooth_printer_repository.dart (+14 more)

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
Nodes (20): _actualQuantity, build, countedItems, createState, _formatDate, initState, isCancelling, isCompleting (+12 more)

### Community 35 - "items_cubit.dart"
Cohesion: 0.22
Nodes (13): ItemCatalogCubit, ItemCatalogFailure, ItemCatalogInitial, ItemCatalogLoading, ItemCatalogState, ItemCatalogSuccess, items, message (+5 more)

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
Nodes (20): carton_piece_quantity.dart, ../extensions/inventory_number_parsing.dart, active, code, copyWith, currentStockBalance, currentStockPieces, fromMap (+12 more)

### Community 40 - "selectable_item_card.dart"
Cohesion: 0.17
Nodes (11): dart:typed_data, connect, connectionProfile, discoverPrinters, loadSelectedPrinter, printReceiptPng, saveSelectedPrinter, ../models/printer_connection_profile.dart (+3 more)

### Community 41 - "../../../../core/constants/app_colors.dart"
Cohesion: 0.18
Nodes (11): ../../../../core/shared_widgets/custom_button.dart, ../../cubit/transactions_cubit.dart, ../../cubit/transactions_state.dart, _actualQuantity, AdjustmentForm, _AdjustmentFormState, createState, dispose (+3 more)

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
Nodes (15): class, ../../data/models/inventory_movement.dart, build, _confirm, createState, _DetailChip, details, _isSaving (+7 more)

### Community 46 - "item_model.dart"
Cohesion: 0.12
Nodes (22): ../../cubit/login/login_cubit.dart, ../../cubit/login/login_state.dart, FormState, LoginCubit, LoginFailure, LoginInitial, LoginState, LoginSubmitting (+14 more)

### Community 47 - "transaction_list_item.dart"
Cohesion: 0.15
Nodes (12): ../constants/app_colors.dart, ../constants/app_text_styles.dart, actions, build, CustomAppBar, leading, preferredSize, title (+4 more)

### Community 48 - "firebase_auth_repository.dart"
Cohesion: 0.11
Nodes (18): auth_failure.dart, auth_repository.dart, bool get, FirebaseAuth, AuthRepository, isSignedIn, signInWithEmailAndPassword, signOut (+10 more)

### Community 49 - "MovementHistoryCubit"
Cohesion: 0.20
Nodes (9): ../../data/models/warehouse_return_record.dart, close, loadPendingReturns, _pendingReturns, _repository, resolveReturn, _resolvingReturnId, _subscription (+1 more)

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
Cohesion: 0.11
Nodes (18): cartons, date, deliveredBy, documentTitle, driverName, itemCode, itemName, lines (+10 more)

### Community 54 - "../constants/app_colors.dart"
Cohesion: 0.20
Nodes (16): ../../data/models/return_resolution.dart, ReturnResolutionCubit, message, pendingReturns, resolution, returnId, ReturnResolutionFailure, ReturnResolutionInitial (+8 more)

### Community 55 - "../../../dashboard/data/models/item_model.dart"
Cohesion: 0.33
Nodes (10): AppRouter, StocktakeCubit, StocktakeActionInProgress, StocktakeCancelled, StocktakeCompleted, StocktakeFailure, StocktakeInitial, StocktakeLoading (+2 more)

### Community 56 - "responsive_layout.dart"
Cohesion: 0.12
Nodes (17): ../constants/app_routes.dart, ../constants/app_strings.dart, GoRouterState, build, child, _confirmLogout, MainShellScreen, state (+9 more)

### Community 57 - "dashboard_screen.dart"
Cohesion: 0.04
Nodes (46): DateTime, int?, id, itemCode, itemId, itemName, itemsPerCarton, quantityPieces (+38 more)

### Community 58 - "auth_failure.dart"
Cohesion: 0.10
Nodes (16): Exception, AuthFailure, message, toString, ItemsRepositoryFailure, message, toString, message (+8 more)

### Community 59 - "Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اجعل الكمية إدخال يدوي وأضف مدة للجرد وتوقيت صحيح ونسخ احتياطي Firebase وبسط المرتجع مع تاريخه, Source Nodes

### Community 60 - "auth_session_notifier.dart"
Cohesion: 0.14
Nodes (13): dashboard_state.dart, ../data/repositories/dashboard_repository_base.dart, _allItems, _buildSummary, close, _debounceTimer, _emitFilteredItems, _itemsSubscription (+5 more)

### Community 61 - "stock_summary_model.dart"
Cohesion: 0.18
Nodes (10): Key, _buildActionButton, color, icon, key, onPrintStockBalance, onTap, _QuickAction (+2 more)

### Community 62 - "saved_printer.dart"
Cohesion: 0.22
Nodes (8): int get, address, displayName, hashCode, name, operator, SavedPrinter, String get

### Community 63 - "login_cubit.dart"
Cohesion: 0.22
Nodes (8): InventoryItem, MovementLineViewData, build, item, onTap, SelectableItemCard, selectedLine, movement_ui_types.dart

### Community 64 - "build"
Cohesion: 0.40
Nodes (4): itemsPerCarton, name, NewInventoryItemDraft, openingStockPieces

### Community 65 - "inventory_item_selector_field.dart"
Cohesion: 0.17
Nodes (11): ../../cubit/item_catalog_cubit.dart, ../../cubit/item_catalog_state.dart, build, createState, items, label, onSelected, _openPicker (+3 more)

### Community 66 - "ItemsCubit"
Cohesion: 0.31
Nodes (10): ItemsCubit, item, ItemsFailure, ItemsInitial, ItemsLoading, ItemsState, ItemsSuccess, message (+2 more)

### Community 67 - "inventory_number_parsing.dart"
Cohesion: 0.27
Nodes (10): DashboardScreen, _DashboardScreenState, _InventoryItemPickerSheet, _InventoryItemPickerSheetState, _ReturnResolutionDialog, _ReturnResolutionDialogState, _StocktakeLineCard, _StocktakeLineCardState (+2 more)

### Community 68 - "package:go_router/go_router.dart"
Cohesion: 0.12
Nodes (15): ../data/models/printer_connection_profile.dart, ../../data/models/printer_discovery_snapshot.dart, ../../data/models/saved_printer.dart, double?, availability, connectionProfile, copyWith, discoveredPrinters (+7 more)

### Community 69 - "StatelessWidget"
Cohesion: 0.11
Nodes (18): ../data/repositories/stocktake_repository_base.dart, ../data/repositories/stocktake_repository_failure.dart, Duration, cancelStocktake, close, completeStocktake, _currentLinesFor, _isActing (+10 more)

### Community 70 - "return_resolution.dart"
Cohesion: 0.20
Nodes (10): ../../../../core/shared_widgets/carton_piece_quantity_fields.dart, ../../cubit/items_cubit.dart, ../../cubit/items_state.dart, AddItemForm, _AddItemFormState, createState, dispose, _itemsPerCartonController (+2 more)

### Community 71 - "transaction_filter_bar.dart"
Cohesion: 0.12
Nodes (15): app_routes.dart, ../../features/auth/cubit/login/login_cubit.dart, ../../features/auth/data/repositories/auth_repository.dart, ../../features/auth/presentation/routing/auth_session_notifier.dart, ../../features/auth/presentation/screens/login_screen.dart, ../../features/dashboard/presentation/screens/dashboard_screen.dart, ../../features/items/presentation/screens/add_item_screen.dart, ../../features/returns/presentation/screens/warehouse_return_screen.dart (+7 more)

### Community 72 - "printer_connection_profile.dart"
Cohesion: 0.22
Nodes (8): androidBluetooth, isSupported, mode, persistsSelectionAcrossSessions, PrinterConnectionMode, PrinterConnectionProfile, unsupported, static const

### Community 73 - "add_item_form.dart"
Cohesion: 0.20
Nodes (9): counters, FirestoreCollections, inventoryControl, items, movements, returns, stocktakeLines, stocktakes (+1 more)

### Community 74 - "warehouse_return_screen.dart"
Cohesion: 0.22
Nodes (9): ../../../../core/constants/app_routes.dart, ../../cubit/return_resolution_cubit.dart, ../../../items/cubit/item_catalog_cubit.dart, createState, _ReturnPersistenceNotice, WarehouseReturnScreen, _WarehouseReturnScreenState, ../widgets/return_workflow_card.dart (+1 more)

### Community 75 - "LoginCubit"
Cohesion: 0.12
Nodes (16): ../../data/mappers/movement_receipt_mapper.dart, MovementRecord, build, _DetailText, _formatDate, _itemsLabel, label, movement (+8 more)

### Community 76 - "CartonPieceQuantity"
Cohesion: 0.33
Nodes (5): CartonPieceQuantity, cartons, fromTotalPieces, pieces, totalPiecesFor

### Community 77 - "AppRoutes.transactionHistory"
Cohesion: 0.18
Nodes (10): cancelStocktake, completeStocktake, fetchOpenStocktake, saveCount, startStocktake, StocktakeRepositoryBase, watchLines, StocktakeRepository (+2 more)

### Community 78 - "main.dart"
Cohesion: 0.12
Nodes (16): core/di/service_locator.dart, core/theme/app_theme.dart, features/dashboard/cubit/dashboard_cubit.dart, features/items/cubit/item_catalog_cubit.dart, features/items/cubit/items_cubit.dart, features/printing/cubit/printer_cubit.dart, features/returns/cubit/return_resolution_cubit.dart, features/returns/cubit/returns_cubit.dart (+8 more)

### Community 79 - "warehouse_return_draft.dart"
Cohesion: 0.09
Nodes (26): ../../data/models/warehouse_return_draft.dart, ../data/repositories/returns_repository_base.dart, ../data/repositories/returns_repository_failure.dart, createCustomerReturn, _isSaving, _repository, ReturnsCubit, _validateDraft (+18 more)

### Community 80 - "outbound_entry_screen.dart"
Cohesion: 0.29
Nodes (6): ../data/models/new_inventory_item_draft.dart, ../data/repositories/items_repository_base.dart, ../data/repositories/items_repository_failure.dart, items_state.dart, _repository, submitNewItem

### Community 81 - "start_stocktake_card.dart"
Cohesion: 0.22
Nodes (8): ../constants/app_sizes.dart, build, _buildNavItem, currentRoute, _isSecondaryMovementRoute, onLogout, TabletNavigationRail, VoidCallback

### Community 82 - "stocktake_session.dart"
Cohesion: 0.12
Nodes (15): adjustedItemCount, cancelledAt, completedAt, id, movementVoucherNumber, netDifferencePieces, notes, periodFrom (+7 more)

### Community 83 - "transaction_history_screen.dart"
Cohesion: 0.11
Nodes (22): MovementHistoryCubit, build, color, createState, _DateFilterBar, initState, label, _MovementReportSummaryBar (+14 more)

### Community 84 - "firebase_options.dart"
Cohesion: 0.20
Nodes (9): android, DefaultFirebaseOptions, ios, macos, web, windows, package:firebase_core/firebase_core.dart, package:flutter/foundation.dart (+1 more)

### Community 85 - "movement_report_summary.dart"
Cohesion: 0.18
Nodes (10): customerReturnPieces, fromMovements, inboundPieces, movementCount, MovementReportSummary, outboundPieces, stocktakeAdjustmentNetPieces, supplierReplacementCount (+2 more)

### Community 86 - "responsive_layout.dart"
Cohesion: 0.25
Nodes (7): build, isMobile, isTablet, mobileLayout, ResponsiveLayout, tabletLayout, Widget

### Community 87 - "stocktake_repository_base.dart"
Cohesion: 0.18
Nodes (10): dart:async, ../../data/repositories/auth_repository.dart, item_catalog_state.dart, dispose, _subscription, close, loadItems, _repository (+2 more)

### Community 88 - "LoginCubit"
Cohesion: 0.22
Nodes (8): IconData, backgroundColor, build, CustomButton, icon, isLoading, onPressed, text

### Community 89 - "dashboard_screen.dart"
Cohesion: 0.24
Nodes (12): ../../data/models/stock_summary_model.dart, DashboardCubit, allItems, DashboardFailure, DashboardInitial, DashboardLoading, DashboardState, DashboardSuccess (+4 more)

### Community 90 - "../../../../core/constants/app_colors.dart"
Cohesion: 0.29
Nodes (6): ../../cubit/movement_history_cubit.dart, ../../cubit/movement_history_state.dart, ../../data/models/movement_record.dart, build, _buildFilterChip, TransactionFilterBar

### Community 91 - "responsive_layout.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: انا عملت الرولز allow read, write if true ولم يسجل خالص، عاوز حل, Source Nodes

### Community 92 - "stock_summary_model.dart"
Cohesion: 0.25
Nodes (7): fromJson, lowStockItemsCount, StockSummaryModel, toJson, totalInboundCount, totalItemsCount, totalOutboundCount

### Community 93 - "../../../../core/constants/app_text_styles.dart"
Cohesion: 0.22
Nodes (8): kind, movementId, returnId, returnNumber, ReturnResolutionDraft, ReturnResolutionKind, SavedReturnResolution, supplierName

### Community 94 - "item_catalog_cubit.dart"
Cohesion: 0.13
Nodes (14): ../data/repositories/printer_repository_base.dart, close, _discoverySubscription, initialize, _initialized, _printInProgress, printReceipt, renderPng (+6 more)

### Community 95 - "dashboard_screen.dart"
Cohesion: 0.17
Nodes (11): ../../../../core/shared_widgets/custom_text_field.dart, ../../data/mappers/stock_balance_receipt_mapper.dart, build, createState, initState, build, ../../../printing/presentation/widgets/thermal_receipt_dialog.dart, AppRoutes.transactionHistory (+3 more)

### Community 96 - "../../../../core/models/inventory_item.dart"
Cohesion: 0.22
Nodes (8): dashboard_repository_base.dart, ../../../items/data/repositories/items_repository_base.dart, DashboardRepositoryBase, DashboardRepository, _itemsRepository, watchItems, ItemsRepositoryBase, ItemsRepository

### Community 97 - "List"
Cohesion: 0.29
Nodes (6): availability, devices, message, PrinterDiscoveryAvailability, List, saved_printer.dart

### Community 98 - "bluetooth_printer_repository.dart"
Cohesion: 0.12
Nodes (15): connect, discoverPrinters, loadSelectedPrinter, _preferencesChannel, _printOnce, printReceiptPng, saveSelectedPrinter, _searchFailureMessage (+7 more)

### Community 99 - "thermal_receipt_content.dart"
Cohesion: 0.19
Nodes (13): CustomTextField, build, index, label, line, receipt, _ReceiptDetail, _ReceiptDivider (+5 more)

### Community 100 - "dashboard_screen.dart"
Cohesion: 0.12
Nodes (16): ../../../../core/constants/app_sizes.dart, core/constants/app_strings.dart, ../../../../core/constants/app_text_styles.dart, ../../../../core/shared_widgets/custom_app_bar.dart, ../../cubit/dashboard_cubit.dart, ../../cubit/dashboard_state.dart, build, _buildItemCard (+8 more)

### Community 101 - "Q: خطه عمل للمرتجع اللي هيتم رجوعه للمورد نفسه يعني مرتيح المخزن مظبوط وبيرجع للمخزن ك رصيد ازاي اعمل بقا مرتحع للمودر نفسه يعني ياخد بضاعه وتتسجب انها مرتحع للمودر وتنقص من رصيد مخزن هل هي موجوده بشكل تاني ؟"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: خطه عمل للمرتجع اللي هيتم رجوعه للمورد نفسه يعني مرتيح المخزن مظبوط وبيرجع للمخزن ك رصيد ازاي اعمل بقا مرتحع للمودر نفسه يعني ياخد بضاعه وتتسجب انها مرتحع للمودر وتنقص من رصيد مخزن هل هي موجوده بشكل تاني ؟, Source Nodes

### Community 102 - "firestore_collections.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: دي هتكون ايقونات التطبيق وعاوز احط لوجو منهم في اول ريسيت الطباعه من فوق بشكل احترافي ويوجود تشويش في الطباعه هل لها من حل ام لا وفي اسفل الريسيت عند اجمالي القطع يكون اجمالي كم كرتونه وتحتهم كام قطعه اعمل الخطه, Source Nodes

### Community 103 - "stock_summary_model.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: لايسجل, Source Nodes

### Community 104 - "String?"
Cohesion: 0.50
Nodes (3): InventoryNumberParsing, toInventoryInteger, String?

### Community 105 - "build"
Cohesion: 0.38
Nodes (7): build, build, AppRoutes.addItem, AppRoutes.newInboundMovement, AppRoutes.newOutboundMovement, AppRoutes.stockAdjustment, AppRoutes.warehouseReturn

### Community 106 - "Q: تشخيص فشل تسجيل الدخول الظاهر في Screenshot 2026-07-29"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: تشخيص فشل تسجيل الدخول الظاهر في Screenshot 2026-07-29, Source Nodes

### Community 107 - "AppRoutes.transactionHistory"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: يعني اي مشكله لازم احط الايميل في الرولز, Source Nodes

### Community 108 - "AuthSessionNotifier"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اصلحه لاضافه اي ايميل يدوي يسجل دخول, Source Nodes

### Community 109 - "stock_balance_receipt_mapper.dart"
Cohesion: 0.25
Nodes (7): ../../../../core/models/carton_piece_quantity.dart, _buildReference, _formatDateTime, fromItems, StockBalanceReceiptMapper, _twoDigits, _

### Community 110 - "../../../../core/models/inventory_item.dart"
Cohesion: 0.29
Nodes (5): ../../../../core/models/inventory_item.dart, watchItems, addItem, watchActiveItems, ../models/new_inventory_item_draft.dart

### Community 111 - "Q: إضافة شعار EL SAUDI أعلى الريسيت وإجمالي الكراتين ثم القطع وتحسين وضوح الطباعة"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: إضافة شعار EL SAUDI أعلى الريسيت وإجمالي الكراتين ثم القطع وتحسين وضوح الطباعة, Source Nodes

### Community 112 - "Q: خطة آمنة لتعديل وحذف الأصناف مع سجل تدقيق وطباعة الحركات وطباعة رصيد المخزن بالكامل"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: خطة آمنة لتعديل وحذف الأصناف مع سجل تدقيق وطباعة الحركات وطباعة رصيد المخزن بالكامل, Source Nodes

### Community 113 - "PrinterRepositoryBase"
Cohesion: 0.67
Nodes (3): PrinterDiscoverySnapshot, BluetoothPrinterRepository, PrinterRepositoryBase

## Knowledge Gaps
- **998 isolated node(s):** `AppColors`, `primary`, `primaryLight`, `primaryDark`, `secondary` (+993 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Work-memory lessons

**Preferred sources** — corroborated by past sessions; start here.
- `LoginCubit` (5× useful, score=4.819844287)
- `FirebaseAuthRepository` (5× useful, score=4.819844287)
- `NewMovementScreen` (5× useful, score=4.777235265)
- `TransactionsCubit` (5× useful, score=4.700245311)
- `AuthSessionNotifier` (4× useful, score=3.856671903)
- `WarehouseReturnForm` (3× useful, score=2.902193185)
- `TransactionsRepository` (3× useful, score=2.887388395)
- `StockAdjustmentScreen` (3× useful, score=2.857593183)
- `AppRouter` (3× useful, score=2.8550559)
- `TransactionModel` (3× useful, score=2.827092057)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `MovementReportSummary` connect `movement_report_summary.dart` to `transaction_history_screen.dart`, `TransactionsCubit`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **Why does `TransactionType` connect `transactions_cubit.dart` to `item_model.dart`, `transactions_state.dart`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Why does `PrinterCubit` connect `stock_summary_card.dart` to `items_cubit.dart`, `main.dart`, `TransactionsCubit`, `package:flutter/material.dart`, `item_catalog_cubit.dart`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **What connects `AppColors`, `primary`, `primaryLight` to the rest of the system?**
  _998 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_strings.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.028169014084507043 - nodes in this community are weakly interconnected._
- **Should `StatelessWidget` be split into smaller, more focused modules?**
  _Cohesion score 0.06628787878787878 - nodes in this community are weakly interconnected._
- **Should `app_router.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._