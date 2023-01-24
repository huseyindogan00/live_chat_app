// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:live_chat_app/ui/components/base/base_components.dart';

class PlatformSensitiveAlertDialog extends BaseComponents {
  final String content;
  final String title;
  final String doneButtonTitle;
  final String? cancelButtonTitle;

  const PlatformSensitiveAlertDialog({
    super.key,
    required this.content,
    required this.title,
    required this.doneButtonTitle,
    this.cancelButtonTitle,
  });

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false,
          )
        : showDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false,
          );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActionButton(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActionButton(context),
    );
  }

  List<Widget> _buildActionButton(BuildContext context) {
    final allButton = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonTitle != null) {
        allButton.add(
          CupertinoDialogAction(
            child: Text(cancelButtonTitle!),
            onPressed: () => Navigator.pop(context),
          ),
        );
      }
      allButton.add(
        CupertinoDialogAction(
          child: Text(doneButtonTitle),
          onPressed: () => Navigator.pop(context),
        ),
      );
    } else if (Platform.isAndroid) {
      if (cancelButtonTitle != null) {
        allButton.add(CupertinoDialogAction(
          child: Text(cancelButtonTitle!),
          onPressed: () => Navigator.pop(context),
        ));
      }
      allButton.add(
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(doneButtonTitle),
        ),
      );
    }
    return allButton;
  }
}
