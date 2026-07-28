import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../items/cubit/item_catalog_cubit.dart';
import '../widgets/outbound_form.dart';

class OutboundEntryScreen extends StatefulWidget {
  const OutboundEntryScreen({super.key});

  @override
  State<OutboundEntryScreen> createState() => _OutboundEntryScreenState();
}

class _OutboundEntryScreenState extends State<OutboundEntryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemCatalogCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.outboundTitle),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: const OutboundForm(),
          ),
        ),
      ),
    );
  }
}
