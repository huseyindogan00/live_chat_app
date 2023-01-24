import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class BaseComponents extends StatelessWidget {
  const BaseComponents({super.key});

  Widget buildAndroidWidget(BuildContext context);
  Widget buildIOSWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildIOSWidget(context);
    }
    return buildAndroidWidget(context);
  }
}
