import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/ui/components/common/bottom_navi/tab_item.dart';

class MyCustomBottomNavigator extends StatelessWidget {
  const MyCustomBottomNavigator({
    super.key,
    required this.currentTab,
    required this.onSelectedTab,
    required this.createdPage,
    required this.navigatorKeys,
  });

  final TabItemEnum currentTab;
  final ValueChanged<TabItemEnum> onSelectedTab;
  final Map<TabItemEnum, Widget> createdPage;
  final Map<TabItemEnum, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createNavItem(TabItemEnum.USERS),
          _createNavItem(TabItemEnum.TALKS),
          _createNavItem(TabItemEnum.PROFILE),
        ],
        onTap: (index) => onSelectedTab(TabItemEnum.values[index]),
      ),
      tabBuilder: (context, index) {
        final viewItem = TabItemEnum.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[viewItem],
          builder: (context) {
            return createdPage[viewItem]!;
          },
        );
      },
    );
  }

  BottomNavigationBarItem _createNavItem(TabItemEnum tabItem) {
    final _createTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(_createTab!.icon),
      label: _createTab.title,
    );
  }
}
