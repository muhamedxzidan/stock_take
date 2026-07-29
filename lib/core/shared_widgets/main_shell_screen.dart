import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';
import '../constants/app_routes.dart';
import '../responsive/responsive_layout.dart';
import 'tablet_navigation_rail.dart';
import 'worker_bottom_navigation.dart';

/// MainShellScreen provides a persistent tablet shell wrapper for GoRouter ShellRoute.
class MainShellScreen extends StatelessWidget {
  final Widget child;
  final GoRouterState state;
  final Future<void> Function() onLogout;

  const MainShellScreen({
    super.key,
    required this.child,
    required this.state,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = state.matchedLocation;

    if (currentRoute == AppRoutes.login) {
      return child;
    }

    return ResponsiveLayout(
      mobileLayout: Scaffold(
        body: child,
        bottomNavigationBar: WorkerBottomNavigation(
          currentRoute: currentRoute,
          onLogout: () => _confirmLogout(context),
        ),
      ),
      tabletLayout: Scaffold(
        body: Row(
          children: [
            TabletNavigationRail(
              currentRoute: currentRoute,
              onLogout: () => _confirmLogout(context),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.logout),
          content: const Text(AppStrings.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(AppStrings.logout),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) {
      return;
    }

    try {
      await onLogout();
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.logoutFailure)));
    }
  }
}
