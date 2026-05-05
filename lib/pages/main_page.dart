import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dashboard_page.dart';
import 'live_tracking_page.dart';
import 'notification_page.dart';
import 'asset_page.dart';
import 'analytics_page.dart';

// ── Tab notifier — agar child page bisa trigger ganti tab ─────────

class MainPageTabNotifier extends InheritedWidget {
  final void Function(int) goTo;

  const MainPageTabNotifier({
    super.key,
    required this.goTo,
    required super.child,
  });

  static MainPageTabNotifier? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MainPageTabNotifier>();

  @override
  bool updateShouldNotify(MainPageTabNotifier old) => false;
}

// ── MainPage ──────────────────────────────────────────────────────

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Index: 0=Home 1=Aset 2=Live 3=Notif 4=Analitik
  late final List<Widget> _pages = [
    const DashboardPage(),
    const AssetPage(),
    const LiveTrackingPage(),
    const NotificationPage(),
    const AnalyticsPage(),
  ];

  void _goToTab(int idx) => setState(() => _currentIndex = idx);

  @override
  Widget build(BuildContext context) {
    return MainPageTabNotifier(
      goTo: _goToTab,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(
            key: ValueKey(_currentIndex),
            child: _pages[_currentIndex],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTab: _goToTab,
        ),
      ),
    );
  }
}