import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/pages/talk/talk_page.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';

class FutureUsersWidget extends StatefulWidget {
  FutureUsersWidget({super.key, required this.userViewModel, this.isTalks = false});
  final UserViewModel userViewModel;
  bool isTalks;

  @override
  State<FutureUsersWidget> createState() => _FutureUsersWidgetState();
}

class _FutureUsersWidgetState extends State<FutureUsersWidget> {
  late final UserViewModel _userViewModel;
  late final bool _isTalks;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey2 = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _userViewModel = widget.userViewModel;
    _isTalks = widget.isTalks;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(),
    );
  }
}
