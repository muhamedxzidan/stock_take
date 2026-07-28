import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../items/cubit/item_catalog_cubit.dart';
import '../widgets/adjustment_form.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemCatalogCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.stocktake,
        leading: IconButton(
          key: const Key('stocktake-to-new-movement'),
          tooltip: AppStrings.backToNewMovement,
          onPressed: () => context.go(AppRoutes.newMovement),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: const AdjustmentForm(),
          ),
        ),
      ),
    );
  }
}
