import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class ReturnWorkflowCard extends StatelessWidget {
  const ReturnWorkflowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.p8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: Text(
                    'مسار المرتجع عند ربط المنطق',
                    style: AppTextStyles.heading2,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h20),
            const _WorkflowStep(
              number: '1',
              title: 'ربط إذن الصرف',
              description: 'التحقق من رقم الإذن والصنف والكمية المصروفة.',
              isLast: false,
            ),
            const _WorkflowStep(
              number: '2',
              title: 'فحص حالة الصنف',
              description:
                  'تحديد ما إذا كان صالحًا للرصيد أو تالفًا أو يحتاج فحصًا.',
              isLast: false,
            ),
            const _WorkflowStep(
              number: '3',
              title: 'اعتماد حركة المرتجع',
              description: 'إنشاء الحركة وتحديث الرصيد بعد موافقة المستخدم.',
              isLast: true,
            ),
            SizedBox(height: AppSizes.h16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.warningBackground,
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Text(
                'حاليًا: العرض وإدخال البيانات فقط، بدون حفظ أو تأثير على المخزون.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF92400E),
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool isLast;

  const _WorkflowStep({
    required this.number,
    required this.title,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.h20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading3),
                  SizedBox(height: AppSizes.h4),
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
