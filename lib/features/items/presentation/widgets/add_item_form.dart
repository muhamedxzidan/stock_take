import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../cubit/items_cubit.dart';
import '../../cubit/items_state.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _itemsPerCartonController = TextEditingController(text: '12');
  final _initialBalanceController = TextEditingController(text: '0');

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _itemsPerCartonController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemsCubit, ItemsState>(
      listenWhen: (prev, curr) => curr is ItemsSuccess || curr is ItemsFailure,
      listener: (context, state) {
        if (state is ItemsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.successSave),
              backgroundColor: AppColors.success,
            ),
          );
          // Navigate safely using GoRouter instead of Navigator.pop which breaks ShellRoute
          context.go(AppRoutes.dashboard);
        }
        if (state is ItemsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      buildWhen: (prev, curr) =>
          curr is ItemsLoading || curr is ItemsInitial || curr is ItemsFailure,
      builder: (context, state) {
        final isLoading = state is ItemsLoading;
        return Column(
          children: [
            CustomTextField(
              label: AppStrings.itemName,
              hint: 'مثال: شامبو لوريال 400 مل',
              controller: _nameController,
              prefixIcon: Icons.shopping_bag,
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.itemCode,
              hint: 'مثال: ITM-101',
              controller: _codeController,
              prefixIcon: Icons.qr_code,
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.itemsPerCarton,
              hint: 'مثال: 12',
              keyboardType: TextInputType.number,
              controller: _itemsPerCartonController,
              prefixIcon: Icons.grid_view,
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: '${AppStrings.initialBalance} بالقطعة',
              hint: '0',
              keyboardType: TextInputType.number,
              controller: _initialBalanceController,
              prefixIcon: Icons.input_sharp,
            ),
            SizedBox(height: AppSizes.h32),
            CustomButton(
              text: AppStrings.save,
              icon: Icons.check_circle,
              isLoading: isLoading,
              onPressed: () {
                context.read<ItemsCubit>().submitNewItem(
                  name: _nameController.text,
                  code: _codeController.text,
                  itemsPerCartonStr: _itemsPerCartonController.text,
                  initialBalanceStr: _initialBalanceController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
