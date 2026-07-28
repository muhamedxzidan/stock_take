import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../items/cubit/item_catalog_cubit.dart';
import '../../cubit/return_resolution_cubit.dart';
import '../widgets/return_workflow_card.dart';
import '../widgets/warehouse_return_form.dart';

class WarehouseReturnScreen extends StatefulWidget {
  const WarehouseReturnScreen({super.key});

  @override
  State<WarehouseReturnScreen> createState() => _WarehouseReturnScreenState();
}

class _WarehouseReturnScreenState extends State<WarehouseReturnScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemCatalogCubit>().loadItems();
    context.read<ReturnResolutionCubit>().loadPendingReturns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.warehouseReturnTitle,
        leading: IconButton(
          key: const Key('return-to-new-movement'),
          tooltip: AppStrings.backToNewMovement,
          onPressed: () => context.go(AppRoutes.newMovement),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                const _ReturnPersistenceNotice(),
                SizedBox(height: AppSizes.h20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 820) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 3, child: WarehouseReturnForm()),
                          SizedBox(width: AppSizes.p20),
                          const Expanded(flex: 2, child: ReturnWorkflowCard()),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        const WarehouseReturnForm(),
                        SizedBox(height: AppSizes.h20),
                        const ReturnWorkflowCard(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReturnPersistenceNotice extends StatelessWidget {
  const _ReturnPersistenceNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB)),
          SizedBox(width: AppSizes.p12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.returnUiNoticeTitle,
                  style: TextStyle(
                    color: Color(0xFF1E40AF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppStrings.returnUiNoticeBody,
                  style: TextStyle(color: Color(0xFF1D4ED8), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
