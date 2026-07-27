---
type: "query"
date: "2026-07-26T23:27:27.197460+00:00"
question: "استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها"
contributor: "graphify"
outcome: "useful"
source_nodes: ["Cubit", "state", "package:flutter_bloc/flutter_bloc.dart", "MultiBlocProvider", "DashboardCubit", "ItemsCubit", "TransactionsCubit"]
---

# Q: استخدم باكدج flutter bloc عشان هنستخدم كيوبت منها

## Answer

Expanded from original query via graph vocab: [flutter, bloc, cubit, state]. The project already imports package:flutter_bloc/flutter_bloc.dart, provides DashboardCubit, ItemsCubit, and TransactionsCubit through MultiBlocProvider, and resolves flutter_bloc 9.1.1. The direct constraint was aligned to ^9.1.1. flutter analyze passed; the existing widget smoke test fails because DashboardRepository.fetchStockSummary leaves a 300ms timer pending after widget disposal, unrelated to the dependency.

## Outcome

- Signal: useful

## Source Nodes

- Cubit
- state
- package:flutter_bloc/flutter_bloc.dart
- MultiBlocProvider
- DashboardCubit
- ItemsCubit
- TransactionsCubit