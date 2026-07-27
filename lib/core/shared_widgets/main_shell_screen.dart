import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../responsive/responsive_layout.dart';
import 'tablet_navigation_rail.dart';

/// MainShellScreen provides a persistent tablet shell wrapper for GoRouter ShellRoute.
class MainShellScreen extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const MainShellScreen({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = state.uri.toString();

    return ResponsiveLayout(
      mobileLayout: child,
      tabletLayout: Scaffold(
        body: Row(
          children: [
            TabletNavigationRail(currentRoute: currentRoute),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
