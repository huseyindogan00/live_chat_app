import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItemEnum {
  USERS,
  TALKS,
  PROFILE,
}

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItemEnum, TabItemData> allTabs = {
    TabItemEnum.USERS: TabItemData('Kullanıcılar', Icons.supervised_user_circle),
    TabItemEnum.TALKS: TabItemData('Konuşmalar', Icons.message),
    TabItemEnum.PROFILE: TabItemData('Profil', Icons.person),
  };
}
