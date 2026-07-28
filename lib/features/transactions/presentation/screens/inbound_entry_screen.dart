import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../items/cubit/item_catalog_cubit.dart';
import '../widgets/inbound_form.dart';

class InboundEntryScreen extends StatefulWidget {
  const InboundEntryScreen({super.key});

  @override
  State<InboundEntryScreen> createState() => _InboundEntryScreenState();
}

class _InboundEntryScreenState extends State<InboundEntryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemCatalogCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.inboundTitle),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: const InboundForm(),
          ),
        ),
      ),
    );
  }
}
