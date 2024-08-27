import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_details/Screens/ViewDetails.dart';
import 'package:instagram_details/Screens/WebView.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [WebViewScreen(), ViewDetails()];
  }

  List<PersistentBottomNavBarItem> _getNavItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.install_mobile_outlined),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.app_badge),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      controller: controller,
      items: _getNavItems(),
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(1)
      ),
    );
  }
}
