import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/shared_widgets/carton_piece_quantity_fields.dart';
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
  final _itemsPerCartonController = TextEditingController(text: '12');
  CartonPieceQuantity _openingStock = const CartonPieceQuantity(
    cartons: 0,
    pieces: 0,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _itemsPerCartonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemsCubit, ItemsState>(
      listenWhen: (prev, curr) => curr is ItemsSuccess || curr is ItemsFailure,
      listener: (context, state) {
        if (state is ItemsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppStrings.successSave} كود الصنف: ${state.item.code}',
              ),
              backgroundColor: AppColors.success,
            ),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.dashboard);
          }
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
            InputDecorator(
              decoration: const InputDecoration(
                labelText: AppStrings.itemCode,
                prefixIcon: Icon(Icons.qr_code),
              ),
              child: const Text(
                'يُنشأ تلقائيًا بصيغة S-N-1',
                key: Key('generated-item-code-hint'),
              ),
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.itemsPerCarton,
              hint: 'مثال: 12',
              keyboardType: TextInputType.number,
              controller: _itemsPerCartonController,
              prefixIcon: Icons.grid_view,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: AppSizes.h16),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppStrings.initialBalance,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: AppSizes.h8),
            CartonPieceQuantityFields(
              keyPrefix: 'opening-stock',
              itemsPerCarton:
                  int.tryParse(_itemsPerCartonController.text.trim()) ?? 1,
              onChanged: (value) => _openingStock = value,
            ),
            SizedBox(height: AppSizes.h32),
            CustomButton(
              text: AppStrings.save,
              icon: Icons.check_circle,
              isLoading: isLoading,
              onPressed: () {
                context.read<ItemsCubit>().submitNewItem(
                  name: _nameController.text,
                  itemsPerCartonStr: _itemsPerCartonController.text,
                  openingStockCartons: _openingStock.cartons,
                  openingStockPieces: _openingStock.pieces,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
