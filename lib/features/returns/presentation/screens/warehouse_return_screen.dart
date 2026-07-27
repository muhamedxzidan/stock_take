import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../widgets/return_workflow_card.dart';
import '../widgets/warehouse_return_form.dart';

class WarehouseReturnScreen extends StatelessWidget {
  const WarehouseReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.warehouseReturnTitle),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                const _UiOnlyNotice(),
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

class _UiOnlyNotice extends StatelessWidget {
  const _UiOnlyNotice();

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
