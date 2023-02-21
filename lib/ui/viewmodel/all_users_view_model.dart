import 'package:flutter/material.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';

enum AllUserViewState {
  IDLE,
  ERROR,
  LOADED,
  BUSY,
}

class AllUsersViewModel with ChangeNotifier {
  List<UserModel> _allUsers;
  AllUserViewState _viewState = AllUserViewState.IDLE;

  AllUsersViewModel(){
    _allUsers
  }
  



}
