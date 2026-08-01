# Graph Report - stock_take  (2026-08-02)

## Corpus Check
- 139 files · ~31,092 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1659 nodes · 2367 edges · 115 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `43272dcc`
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
- StatelessWidget
- TransactionsCubit
- Q: اضافه اسم السائق في الاستلام والتسليم
- Q: العميل عاوز يبسط الامور جدا بحيث العامل يفتخ السيستم لما يجي يدوس علي منتج يطلعلو عاوز كام منو هياخد ولا هيخصم منو وبناء علي طلبو هيتحمع في الفاتوره عاوزها مبسطه خالص اقترحلي ال UI
- Q: اعمل الخطه ك ui. بس
- saved_printer.dart
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
- LoginCubit
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
- package:flutter_bloc/flutter_bloc.dart
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
- tablet_navigation_rail.dart
- stocktake_repository_base.dart
- LoginCubit
- dashboard_screen.dart
- ../../../../core/constants/app_colors.dart
- responsive_layout.dart
- stock_summary_model.dart
- String?
- item_catalog_cubit.dart
- ../constants/app_colors.dart
- ../../../../core/models/inventory_item.dart
- List
- bluetooth_printer_repository.dart
- thermal_receipt_content.dart
- dashboard_screen.dart
- Q: خطه عمل للمرتجع اللي هيتم رجوعه للمورد نفسه يعني مرتيح المخزن مظبوط وبيرجع للمخزن ك رصيد ازاي اعمل بقا مرتحع للمودر نفسه يعني ياخد بضاعه وتتسجب انها مرتحع للمودر وتنقص من رصيد مخزن هل هي موجوده بشكل تاني ؟
- firestore_collections.dart
- stock_summary_model.dart
- PrinterRepositoryBase
- item_catalog_cubit.dart
- Q: تشخيص فشل تسجيل الدخول الظاهر في Screenshot 2026-07-29
- AppRoutes.transactionHistory
- AuthSessionNotifier
- ../../../../core/constants/app_text_styles.dart
- Q: Why does printing the complete stock balance corrupt on XP-P802A while short movement receipts print correctly?
- Q: إضافة شعار EL SAUDI أعلى الريسيت وإجمالي الكراتين ثم القطع وتحسين وضوح الطباعة
- Q: خطة آمنة لتعديل وحذف الأصناف مع سجل تدقيق وطباعة الحركات وطباعة رصيد المخزن بالكامل
- package:cloud_firestore/cloud_firestore.dart
- String?

## God Nodes (most connected - your core abstractions)
1. `ReturnResolutionCubit` - 18 edges
2. `ItemCatalogCubit` - 17 edges
3. `PrinterCubit` - 17 edges
4. `MovementHistoryCubit` - 17 edges
5. `StocktakeCubit` - 16 edges
6. `DashboardCubit` - 15 edges
7. `LoginCubit` - 12 edges
8. `ItemsCubit` - 12 edges
9. `ReturnsCubit` - 12 edges
10. `TransactionsCubit` - 12 edges

## Surprising Connections (you probably didn't know these)
- `_resolve` --references--> `ReturnResolutionCubit`  [EXTRACTED]
  lib/features/returns/presentation/widgets/return_workflow_card.dart → lib/features/returns/cubit/return_resolution_cubit.dart
- `_confirm` --references--> `TransactionsCubit`  [EXTRACTED]
  lib/features/transactions/presentation/widgets/movement_voucher_preview_dialog.dart → lib/features/transactions/cubit/transactions_cubit.dart
- `AppRouter` --references--> `LoginCubit`  [EXTRACTED]
  lib/core/constants/app_router.dart → lib/features/auth/cubit/login/login_cubit.dart
- `_submit` --references--> `LoginCubit`  [EXTRACTED]
  lib/features/auth/presentation/screens/login_screen.dart → lib/features/auth/cubit/login/login_cubit.dart
- `initState` --references--> `DashboardCubit`  [EXTRACTED]
  lib/features/dashboard/presentation/screens/dashboard_screen.dart → lib/features/dashboard/cubit/dashboard_cubit.dart

## Import Cycles
- None detected.

## Communities (115 total, 0 thin omitted)

### Community 0 - "app_strings.dart"
Cohesion: 0.03
Nodes (70): actualCount, addItemTitle, adjustmentReason, adjustmentTitle, AppStrings, appTitle, authorizedUsersOnly, backToNewMovement (+62 more)

### Community 1 - "StatelessWidget"
Cohesion: 0.08
Nodes (23): DocumentReference, _counters, createCustomerReturn, _customerReturnCounterId, _ensureInventoryIsUnlocked, _ensureNoLegacyOpenStocktake, _firebaseAuth, _firestore (+15 more)

### Community 2 - "app_router.dart"
Cohesion: 0.09
Nodes (20): ../../../../core/models/thermal_receipt_data.dart, _formatDate, fromMovementRecord, fromSavedMovement, _movementLabel, MovementReceiptMapper, _partyLabel, fromMap (+12 more)

### Community 3 - "TransactionsCubit"
Cohesion: 0.19
Nodes (13): dateFilterMode, dateFrom, dateTo, message, MovementDateFilterMode, MovementHistoryFailure, MovementHistoryInitial, MovementHistoryLoading (+5 more)

### Community 4 - "app_sizes.dart"
Cohesion: 0.04
Nodes (44): app_colors.dart, AppSizes, buttonHeight, cardElevation, h12, h16, h20, h24 (+36 more)

### Community 5 - "main.dart"
Cohesion: 0.12
Nodes (18): ../../../../core/constants/app_colors.dart, ../../cubit/printer_cubit.dart, ../../cubit/printer_state.dart, build, build, _controller, createState, _rasterizer (+10 more)

### Community 6 - "app_colors.dart"
Cohesion: 0.08
Nodes (24): AppColors, background, border, divider, error, errorBackground, info, infoBackground (+16 more)

### Community 7 - "add_item_form.dart"
Cohesion: 0.08
Nodes (23): current_voucher_panel.dart, ../../../items/cubit/item_catalog_state.dart, build, itemCount, _itemCountLabel, movementKind, onAddItem, onContinue (+15 more)

### Community 8 - "DashboardCubit"
Cohesion: 0.27
Nodes (10): CartonPieceQuantityFields, _CartonPieceQuantityFieldsState, _ReturnResolutionDialog, _ReturnResolutionDialogState, _StocktakeLineCard, _StocktakeLineCardState, ItemQuantitySheet, _ItemQuantitySheetState (+2 more)

### Community 9 - "transaction_model.dart"
Cohesion: 0.12
Nodes (15): CollectionReference, ../../../../core/constants/firestore_collections.dart, FirebaseFirestore, items_repository_base.dart, items_repository_failure.dart, addItem, _counters, _firebaseAuth (+7 more)

### Community 10 - "transactions_cubit.dart"
Cohesion: 0.14
Nodes (13): DateTime, actualQuantityPieces, copyWith, counted, countedAt, differencePieces, itemCodeSnapshot, itemId (+5 more)

### Community 11 - "item_model.dart"
Cohesion: 0.18
Nodes (10): ../../data/models/inventory_movement.dart, ../data/repositories/transactions_repository_base.dart, ../data/repositories/transactions_repository_failure.dart, createInboundMovement, createOutboundMovement, _isSavingMovement, _repository, _saveMovement (+2 more)

### Community 12 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.05
Nodes (48): ../../../../core/constants/app_routes.dart, ../../data/models/stocktake_line.dart, ../../data/models/stocktake_session.dart, AppRouter, build, StocktakeCubit, action, completion (+40 more)

### Community 13 - "pdf_voucher_dialog.dart"
Cohesion: 0.22
Nodes (9): ../../../../core/shared_widgets/custom_app_bar.dart, ../../cubit/return_resolution_cubit.dart, ../../../items/cubit/item_catalog_cubit.dart, createState, _ReturnPersistenceNotice, WarehouseReturnScreen, _WarehouseReturnScreenState, ../widgets/return_workflow_card.dart (+1 more)

### Community 14 - "adjustment_form.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اظهر المرتجع والجرد في ابسط صورة للتحكم والتنقل, Source Nodes

### Community 15 - "inbound_form.dart"
Cohesion: 0.12
Nodes (17): class, ../../cubit/transactions_cubit.dart, ../../cubit/transactions_state.dart, InventoryMovementDraft, build, _confirm, createState, _DetailChip (+9 more)

### Community 16 - "outbound_form.dart"
Cohesion: 0.14
Nodes (13): int?, id, itemCode, itemId, itemName, itemsPerCarton, quantityPieces, receivedAt (+5 more)

### Community 17 - "stock_summary_card.dart"
Cohesion: 0.15
Nodes (17): PrinterCubit, PrinterState, build, createState, _cubit, didChangeDependencies, dispose, _filterPrinters (+9 more)

### Community 18 - "dashboard_repository.dart"
Cohesion: 0.17
Nodes (11): build, buttonKey, color, icon, onStocktakeTap, onTap, onWarehouseReturnTap, _SecondaryOperationButton (+3 more)

### Community 19 - "custom_text_field.dart"
Cohesion: 0.09
Nodes (22): FocusNode?, Iterable, autofillHints, build, controller, CustomTextField, enabled, fieldKey (+14 more)

### Community 20 - "transactions_repository.dart"
Cohesion: 0.07
Nodes (26): arabicLabel, counterId, _counters, createInboundMovement, _createInventoryMovement, createOutboundMovement, _ensureInventoryIsUnlocked, _ensureNoLegacyOpenStocktake (+18 more)

### Community 21 - "package:flutter/material.dart"
Cohesion: 0.13
Nodes (15): build, _continue, createState, _dateController, _deliveredByController, dispose, _driverController, initState (+7 more)

### Community 22 - "status_badge.dart"
Cohesion: 0.12
Nodes (17): build, buttonKey, createState, date, _DateButton, dispose, _formatDate, initState (+9 more)

### Community 23 - "custom_button.dart"
Cohesion: 0.07
Nodes (29): _adjustmentCounterId, cancelStocktake, _claimLegacyOpenSession, completeStocktake, _counters, fetchOpenStocktake, _firebaseAuth, _firestore (+21 more)

### Community 24 - "transaction_list_item.dart"
Cohesion: 0.07
Nodes (29): build, build, _changeMovementKind, createState, dispose, initialMovementKind, _lines, _movementKind (+21 more)

### Community 25 - "app_routes.dart"
Cohesion: 0.10
Nodes (19): addItem, AppRoutes, dashboard, login, newInboundMovement, newMovement, newOutboundMovement, stockAdjustment (+11 more)

### Community 26 - "tablet_navigation_rail.dart"
Cohesion: 0.15
Nodes (12): build, _cartons, createState, _exceedsAvailableStock, _hasQuantity, initialSelection, initState, item (+4 more)

### Community 27 - "custom_app_bar.dart"
Cohesion: 0.20
Nodes (9): Color, adjustment, backgroundColor, build, inbound, label, outbound, StatusBadge (+1 more)

### Community 28 - "package:flutter/material.dart"
Cohesion: 0.12
Nodes (16): actionLabel, cartons, date, deliveredBy, driverName, item, label, MovementVoucherDetails (+8 more)

### Community 29 - "transactions_state.dart"
Cohesion: 0.13
Nodes (13): fromMap, _statusFrom, WarehouseReturnFirestoreMapper, createCustomerReturn, resolveReturn, ReturnsRepositoryBase, watchPendingReturns, ReturnsRepository (+5 more)

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
Cohesion: 0.07
Nodes (35): core/constants/app_strings.dart, ../../cubit/dashboard_cubit.dart, ../../cubit/dashboard_state.dart, ../../data/mappers/stock_balance_receipt_mapper.dart, ../../data/models/stock_summary_model.dart, DashboardCubit, allItems, DashboardFailure (+27 more)

### Community 36 - "../../../../core/models/inventory_item.dart"
Cohesion: 0.10
Nodes (20): _allMovements, close, _dateFilterMode, _dateFrom, _dateTo, _emitFilteredMovements, filterByType, loadMovements (+12 more)

### Community 37 - "movement_type_selector.dart"
Cohesion: 0.15
Nodes (12): backgroundColor, build, color, icon, label, _MovementTypeButton, MovementTypeSelector, onChanged (+4 more)

### Community 38 - "current_voucher_panel.dart"
Cohesion: 0.15
Nodes (12): build, CurrentVoucherPanel, _EmptyVoucherState, _itemCountLabel, line, lines, movementKind, onContinue (+4 more)

### Community 39 - "movement_voucher_preview_dialog.dart"
Cohesion: 0.10
Nodes (19): carton_piece_quantity.dart, active, code, copyWith, currentStockBalance, currentStockPieces, fromMap, id (+11 more)

### Community 40 - "StatelessWidget"
Cohesion: 0.12
Nodes (15): custom_text_field.dart, ../extensions/inventory_number_parsing.dart, build, _cartonsController, createState, dispose, initialValue, initState (+7 more)

### Community 41 - "TransactionsCubit"
Cohesion: 0.36
Nodes (9): TransactionsCubit, InventoryMovementFailure, InventoryMovementSaved, InventoryMovementSaving, message, movement, TransactionsInitial, TransactionsState (+1 more)

### Community 42 - "Q: اضافه اسم السائق في الاستلام والتسليم"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اضافه اسم السائق في الاستلام والتسليم, Source Nodes

### Community 43 - "Q: العميل عاوز يبسط الامور جدا بحيث العامل يفتخ السيستم لما يجي يدوس علي منتج يطلعلو عاوز كام منو هياخد ولا هيخصم منو وبناء علي طلبو هيتحمع في الفاتوره عاوزها مبسطه خالص اقترحلي ال UI"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: العميل عاوز يبسط الامور جدا بحيث العامل يفتخ السيستم لما يجي يدوس علي منتج يطلعلو عاوز كام منو هياخد ولا هيخصم منو وبناء علي طلبو هيتحمع في الفاتوره عاوزها مبسطه خالص اقترحلي ال UI, Source Nodes

### Community 44 - "Q: اعمل الخطه ك ui. بس"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اعمل الخطه ك ui. بس, Source Nodes

### Community 45 - "saved_printer.dart"
Cohesion: 0.15
Nodes (13): ../../../../core/shared_widgets/custom_text_field.dart, ../../cubit/returns_cubit.dart, ../../cubit/returns_state.dart, ../../../items/presentation/widgets/inventory_item_selector_field.dart, build, createState, dispose, _quantity (+5 more)

### Community 46 - "item_model.dart"
Cohesion: 0.12
Nodes (22): ../../cubit/login/login_cubit.dart, ../../cubit/login/login_state.dart, FormState, LoginCubit, LoginFailure, LoginInitial, LoginState, LoginSubmitting (+14 more)

### Community 47 - "transaction_list_item.dart"
Cohesion: 0.18
Nodes (10): ../constants/app_colors.dart, ../constants/app_text_styles.dart, actions, build, leading, preferredSize, title, AppTheme (+2 more)

### Community 48 - "firebase_auth_repository.dart"
Cohesion: 0.17
Nodes (11): auth_failure.dart, auth_repository.dart, FirebaseAuth, _firebaseAuth, isSignedIn, mapFirebaseAuthFailureCode, normalizedCode, signInWithEmailAndPassword (+3 more)

### Community 49 - "MovementHistoryCubit"
Cohesion: 0.13
Nodes (14): dart:math, dart:ui, bytes, _cropSlice, height, _maxRasterPayloadBytes, maxSliceHeight, _safeSliceHeight (+6 more)

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
Cohesion: 0.10
Nodes (19): cartons, date, deliveredBy, documentTitle, driverName, itemCode, itemName, lines (+11 more)

### Community 54 - "../constants/app_colors.dart"
Cohesion: 0.12
Nodes (16): ../../cubit/return_resolution_state.dart, build, _confirm, count, _CountBadge, createState, dispose, _EmptyPendingReturns (+8 more)

### Community 55 - "../../../dashboard/data/models/item_model.dart"
Cohesion: 0.22
Nodes (15): ../../data/models/warehouse_return_record.dart, ReturnResolutionCubit, message, pendingReturns, resolution, returnId, ReturnResolutionFailure, ReturnResolutionInitial (+7 more)

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
Cohesion: 0.14
Nodes (13): dashboard_state.dart, ../data/repositories/dashboard_repository_base.dart, _allItems, _buildSummary, close, _debounceTimer, _emitFilteredItems, _itemsSubscription (+5 more)

### Community 61 - "stock_summary_model.dart"
Cohesion: 0.18
Nodes (10): Key, _buildActionButton, color, icon, key, onPrintStockBalance, onTap, _QuickAction (+2 more)

### Community 62 - "LoginCubit"
Cohesion: 0.22
Nodes (8): IconData, backgroundColor, build, CustomButton, icon, isLoading, onPressed, text

### Community 63 - "login_cubit.dart"
Cohesion: 0.20
Nodes (9): connect, connectionProfile, discoverPrinters, loadSelectedPrinter, printReceiptPng, saveSelectedPrinter, ../models/printer_connection_profile.dart, ../models/printer_discovery_snapshot.dart (+1 more)

### Community 64 - "build"
Cohesion: 0.40
Nodes (4): itemsPerCarton, name, NewInventoryItemDraft, openingStockPieces

### Community 65 - "inventory_item_selector_field.dart"
Cohesion: 0.17
Nodes (12): ../../cubit/item_catalog_cubit.dart, ../../cubit/item_catalog_state.dart, build, createState, _InventoryItemPickerSheet, _InventoryItemPickerSheetState, items, label (+4 more)

### Community 66 - "ItemsCubit"
Cohesion: 0.31
Nodes (10): ItemsCubit, item, ItemsFailure, ItemsInitial, ItemsLoading, ItemsState, ItemsSuccess, message (+2 more)

### Community 67 - "inventory_number_parsing.dart"
Cohesion: 0.20
Nodes (9): dart:typed_data, ReceiptImageSlicer, print, _printImage, ReceiptImagePrinter, _sliceImage, ThermalReceiptPrintJob, thermal_receipt_image_slicer.dart (+1 more)

### Community 68 - "package:go_router/go_router.dart"
Cohesion: 0.14
Nodes (13): ../data/models/printer_connection_profile.dart, double?, availability, connectionProfile, copyWith, discoveredPrinters, isConnecting, isPrinting (+5 more)

### Community 69 - "StatelessWidget"
Cohesion: 0.11
Nodes (18): ../data/repositories/stocktake_repository_base.dart, ../data/repositories/stocktake_repository_failure.dart, Duration, cancelStocktake, close, completeStocktake, _currentLinesFor, _isActing (+10 more)

### Community 70 - "return_resolution.dart"
Cohesion: 0.18
Nodes (11): ../../../../core/shared_widgets/carton_piece_quantity_fields.dart, ../../../../core/shared_widgets/custom_button.dart, ../../cubit/items_cubit.dart, ../../cubit/items_state.dart, AddItemForm, _AddItemFormState, createState, dispose (+3 more)

### Community 71 - "transaction_filter_bar.dart"
Cohesion: 0.12
Nodes (15): app_routes.dart, ../../features/auth/cubit/login/login_cubit.dart, ../../features/auth/data/repositories/auth_repository.dart, ../../features/auth/presentation/routing/auth_session_notifier.dart, ../../features/auth/presentation/screens/login_screen.dart, ../../features/dashboard/presentation/screens/dashboard_screen.dart, ../../features/items/presentation/screens/add_item_screen.dart, ../../features/returns/presentation/screens/warehouse_return_screen.dart (+7 more)

### Community 72 - "printer_connection_profile.dart"
Cohesion: 0.22
Nodes (8): androidBluetooth, isSupported, mode, persistsSelectionAcrossSessions, PrinterConnectionMode, PrinterConnectionProfile, unsupported, static const

### Community 73 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.22
Nodes (13): Cubit, ItemCatalogCubit, ItemCatalogFailure, ItemCatalogInitial, ItemCatalogLoading, ItemCatalogState, ItemCatalogSuccess, items (+5 more)

### Community 74 - "warehouse_return_screen.dart"
Cohesion: 0.22
Nodes (8): int get, address, displayName, hashCode, name, operator, SavedPrinter, String get

### Community 75 - "LoginCubit"
Cohesion: 0.13
Nodes (14): ../../data/mappers/movement_receipt_mapper.dart, MovementRecord, build, _formatDate, _itemsLabel, label, movement, _quantityLabel (+6 more)

### Community 76 - "CartonPieceQuantity"
Cohesion: 0.33
Nodes (5): CartonPieceQuantity, cartons, fromTotalPieces, pieces, totalPiecesFor

### Community 77 - "AppRoutes.transactionHistory"
Cohesion: 0.12
Nodes (15): lineFromMap, sessionFromMap, _statusFrom, StocktakeFirestoreMapper, cancelStocktake, completeStocktake, fetchOpenStocktake, saveCount (+7 more)

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
Cohesion: 0.18
Nodes (10): build, _emptyMessage, isError, message, onSelect, printers, PrinterSelectionMessage, PrinterSelectionResults (+2 more)

### Community 82 - "stocktake_session.dart"
Cohesion: 0.20
Nodes (9): ../../data/models/return_resolution.dart, close, loadPendingReturns, _pendingReturns, _repository, resolveReturn, _resolvingReturnId, _subscription (+1 more)

### Community 83 - "transaction_history_screen.dart"
Cohesion: 0.10
Nodes (24): ../../data/models/movement_report_summary.dart, MovementHistoryCubit, build, color, createState, _DateFilterBar, initState, label (+16 more)

### Community 84 - "firebase_options.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: لماذا تتلف طباعة كل الأصناف بينما تطبع حركات المخزن الأخرى سليمة؟, Source Nodes

### Community 85 - "movement_report_summary.dart"
Cohesion: 0.18
Nodes (10): customerReturnPieces, fromMovements, inboundPieces, movementCount, MovementReportSummary, outboundPieces, stocktakeAdjustmentNetPieces, supplierReplacementCount (+2 more)

### Community 86 - "tablet_navigation_rail.dart"
Cohesion: 0.08
Nodes (25): ../constants/app_routes.dart, ../constants/app_sizes.dart, ../constants/app_strings.dart, GoRouterState, build, child, _confirmLogout, MainShellScreen (+17 more)

### Community 87 - "stocktake_repository_base.dart"
Cohesion: 0.18
Nodes (10): dart:async, ../../data/repositories/auth_repository.dart, item_catalog_state.dart, dispose, _subscription, close, loadItems, _repository (+2 more)

### Community 88 - "LoginCubit"
Cohesion: 0.20
Nodes (9): android, DefaultFirebaseOptions, ios, macos, web, windows, package:firebase_core/firebase_core.dart, package:flutter/foundation.dart (+1 more)

### Community 89 - "dashboard_screen.dart"
Cohesion: 0.25
Nodes (7): bool get, AuthRepository, isSignedIn, signInWithEmailAndPassword, signOut, watchAuthentication, FirebaseAuthRepository

### Community 90 - "../../../../core/constants/app_colors.dart"
Cohesion: 0.29
Nodes (6): ../../cubit/movement_history_cubit.dart, ../../cubit/movement_history_state.dart, ../../data/models/movement_record.dart, build, _buildFilterChip, TransactionFilterBar

### Community 91 - "responsive_layout.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: انا عملت الرولز allow read, write if true ولم يسجل خالص، عاوز حل, Source Nodes

### Community 92 - "stock_summary_model.dart"
Cohesion: 0.25
Nodes (7): ../../../../core/models/carton_piece_quantity.dart, _buildReference, _formatDateTime, fromItems, StockBalanceReceiptMapper, _twoDigits, _

### Community 93 - "String?"
Cohesion: 0.18
Nodes (10): ../../data/models/printer_discovery_snapshot.dart, ../data/repositories/printer_repository_base.dart, PrinterDiscoveryController, _repository, start, stop, _subscription, PrinterDiscoverySnapshot (+2 more)

### Community 94 - "item_catalog_cubit.dart"
Cohesion: 0.13
Nodes (14): ../../data/models/saved_printer.dart, close, _discovery, initialize, _initialized, _printInProgress, printReceipt, _repository (+6 more)

### Community 95 - "../constants/app_colors.dart"
Cohesion: 0.29
Nodes (6): ../../data/repositories/auth_failure.dart, _authRepository, _isValidEmail, signIn, login_state.dart, package:flutter_bloc/flutter_bloc.dart

### Community 96 - "../../../../core/models/inventory_item.dart"
Cohesion: 0.14
Nodes (13): ../../../../core/models/inventory_item.dart, dashboard_repository_base.dart, ../../../items/data/repositories/items_repository_base.dart, DashboardRepositoryBase, watchItems, DashboardRepository, _itemsRepository, watchItems (+5 more)

### Community 97 - "List"
Cohesion: 0.18
Nodes (9): InventoryNumberParsing, toInventoryInteger, availability, devices, message, PrinterDiscoveryAvailability, List, saved_printer.dart (+1 more)

### Community 98 - "bluetooth_printer_repository.dart"
Cohesion: 0.12
Nodes (16): connect, discoverPrinters, loadSelectedPrinter, _printerStore, _printImageWithBluetooth, _printJob, printReceiptPng, saveSelectedPrinter (+8 more)

### Community 99 - "thermal_receipt_content.dart"
Cohesion: 0.17
Nodes (11): build, index, label, line, receipt, _ReceiptDetail, _ReceiptDivider, _ReceiptItem (+3 more)

### Community 100 - "dashboard_screen.dart"
Cohesion: 0.33
Nodes (5): ../../../../core/constants/app_text_styles.dart, build, _buildStatItem, StockSummaryCard, summary

### Community 101 - "Q: خطه عمل للمرتجع اللي هيتم رجوعه للمورد نفسه يعني مرتيح المخزن مظبوط وبيرجع للمخزن ك رصيد ازاي اعمل بقا مرتحع للمودر نفسه يعني ياخد بضاعه وتتسجب انها مرتحع للمودر وتنقص من رصيد مخزن هل هي موجوده بشكل تاني ؟"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: خطه عمل للمرتجع اللي هيتم رجوعه للمورد نفسه يعني مرتيح المخزن مظبوط وبيرجع للمخزن ك رصيد ازاي اعمل بقا مرتحع للمودر نفسه يعني ياخد بضاعه وتتسجب انها مرتحع للمودر وتنقص من رصيد مخزن هل هي موجوده بشكل تاني ؟, Source Nodes

### Community 102 - "firestore_collections.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: دي هتكون ايقونات التطبيق وعاوز احط لوجو منهم في اول ريسيت الطباعه من فوق بشكل احترافي ويوجود تشويش في الطباعه هل لها من حل ام لا وفي اسفل الريسيت عند اجمالي القطع يكون اجمالي كم كرتونه وتحتهم كام قطعه اعمل الخطه, Source Nodes

### Community 103 - "stock_summary_model.dart"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: لايسجل, Source Nodes

### Community 104 - "PrinterRepositoryBase"
Cohesion: 0.25
Nodes (7): _channel, load, save, SelectedPrinterStore, ../models/saved_printer.dart, package:flutter/services.dart, static const MethodChannel

### Community 105 - "item_catalog_cubit.dart"
Cohesion: 0.20
Nodes (10): CustomAppBar, _MobileVoucherSummary, _MovementInventoryNotice, NewMovementView, _NoMatchingItems, _DetailText, _MovementRecordDetailsDialog, TransactionListItem (+2 more)

### Community 106 - "Q: تشخيص فشل تسجيل الدخول الظاهر في Screenshot 2026-07-29"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: تشخيص فشل تسجيل الدخول الظاهر في Screenshot 2026-07-29, Source Nodes

### Community 107 - "AppRoutes.transactionHistory"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: يعني اي مشكله لازم احط الايميل في الرولز, Source Nodes

### Community 108 - "AuthSessionNotifier"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: اصلحه لاضافه اي ايميل يدوي يسجل دخول, Source Nodes

### Community 109 - "../../../../core/constants/app_text_styles.dart"
Cohesion: 0.22
Nodes (8): InventoryItem, MovementLineViewData, build, item, onTap, SelectableItemCard, selectedLine, movement_ui_types.dart

### Community 110 - "Q: Why does printing the complete stock balance corrupt on XP-P802A while short movement receipts print correctly?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: Why does printing the complete stock balance corrupt on XP-P802A while short movement receipts print correctly?, Source Nodes

### Community 111 - "Q: إضافة شعار EL SAUDI أعلى الريسيت وإجمالي الكراتين ثم القطع وتحسين وضوح الطباعة"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: إضافة شعار EL SAUDI أعلى الريسيت وإجمالي الكراتين ثم القطع وتحسين وضوح الطباعة, Source Nodes

### Community 112 - "Q: خطة آمنة لتعديل وحذف الأصناف مع سجل تدقيق وطباعة الحركات وطباعة رصيد المخزن بالكامل"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: خطة آمنة لتعديل وحذف الأصناف مع سجل تدقيق وطباعة الحركات وطباعة رصيد المخزن بالكامل, Source Nodes

### Community 113 - "package:cloud_firestore/cloud_firestore.dart"
Cohesion: 0.22
Nodes (8): kind, movementId, returnId, returnNumber, ReturnResolutionDraft, ReturnResolutionKind, SavedReturnResolution, supplierName

### Community 114 - "String?"
Cohesion: 0.40
Nodes (4): ../../../../core/constants/app_sizes.dart, AddItemScreen, build, ../widgets/add_item_form.dart

## Knowledge Gaps
- **1010 isolated node(s):** `AppColors`, `primary`, `primaryLight`, `primaryDark`, `secondary` (+1005 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Work-memory lessons

**Preferred sources** — corroborated by past sessions; start here.
- `FirebaseAuthRepository` (5× useful, score=4.561705341)
- `NewMovementScreen` (5× useful, score=4.521378353)
- `BluetoothPrinterRepository` (3× useful, score=2.943084527) _(code changed — re-verify)_
- `ThermalReceiptDialog` (3× useful, score=2.889626192) _(code changed — re-verify)_
- `ThermalReceiptContent` (3× useful, score=2.887472449)
- `WarehouseReturnForm` (3× useful, score=2.746758892)
- `TransactionsRepository` (3× useful, score=2.73274701)
- `StockItemsList` (3× useful, score=2.720002417)
- `StockAdjustmentScreen` (3× useful, score=2.704547556)
- `AppRouter` (3× useful, score=2.702146164)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `PrinterCubit` connect `stock_summary_card.dart` to `main.dart`, `package:flutter_bloc/flutter_bloc.dart`, `main.dart`, `transaction_history_screen.dart`, `TransactionsCubit`, `item_catalog_cubit.dart`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Why does `MovementHistoryCubit` connect `transaction_history_screen.dart` to `TransactionsCubit`, `../../../../core/models/inventory_item.dart`, `package:flutter_bloc/flutter_bloc.dart`, `main.dart`, `../../../../core/constants/app_colors.dart`, `TransactionsCubit`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **Why does `PrinterRepositoryBase` connect `String?` to `item_catalog_cubit.dart`, `TransactionsCubit`, `login_cubit.dart`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **What connects `AppColors`, `primary`, `primaryLight` to the rest of the system?**
  _1010 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_strings.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.028169014084507043 - nodes in this community are weakly interconnected._
- **Should `StatelessWidget` be split into smaller, more focused modules?**
  _Cohesion score 0.08333333333333333 - nodes in this community are weakly interconnected._
- **Should `app_router.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._