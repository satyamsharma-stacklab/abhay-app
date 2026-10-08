import 'package:flutter/material.dart';

import '../core/constants/strings.dart';
import '../features/contest/contest_page.dart';
import '../features/home/home_page.dart';
import '../features/profile/profile_page.dart';
import '../features/roadmap/roadmap_page.dart';
import '../features/visualization/visualize_page.dart';

/// 5-tab bottom navigation. Har tab ka state IndexedStack se bacha rehta hai.
class AbhayShell extends StatefulWidget {
  const AbhayShell({super.key, required this.themeMode});

  final ValueNotifier<ThemeMode> themeMode;

  static const tabVisualize = 2;

  @override
  State<AbhayShell> createState() => _AbhayShellState();
}

class _AbhayShellState extends State<AbhayShell> {
  int _index = 0;

  void _openTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(AppStrings.appName, style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppStrings.tagline,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(onOpenTab: _openTab),
          const RoadmapPage(),
          const VisualizePage(),
          const ContestPage(),
          ProfilePage(themeMode: widget.themeMode),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _openTab,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: AppStrings.navHome),
          NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: AppStrings.navRoadmap),
          NavigationDestination(
              icon: Icon(Icons.play_circle_outline),
              selectedIcon: Icon(Icons.play_circle),
              label: AppStrings.navVisualize),
          NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined),
              selectedIcon: Icon(Icons.emoji_events),
              label: AppStrings.navContest),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: AppStrings.navProfile),
        ],
      ),
    );
  }
}
