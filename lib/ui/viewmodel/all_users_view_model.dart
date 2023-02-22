import 'package:flutter/material.dart';
import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/user_repository.dart';

enum AllUserViewState {
  IDLE,
  ERROR,
  LOADED,
  BUSY,
}

class AllUsersViewModel with ChangeNotifier {
  List<UserModel>? _allUsers;
  AllUserViewState _viewState = AllUserViewState.IDLE;
  UserModel? _endUser;
  int _numberOfPages = 3;
  final UserRepository _userRepository = locator<UserRepository>();

  List<UserModel>? get allUsersList => _allUsers;
  AllUserViewState get viewState => _viewState;

  set viewState(AllUserViewState value) {
    _viewState = value;
    notifyListeners();
  }

  AllUsersViewModel([this._allUsers, this._endUser]) {
    _allUsers = [];
    _endUser = null;
    fetchUserWithPagination(_endUser);
  }

  void fetchUserWithPagination(UserModel? endUser) async {
    viewState = AllUserViewState.BUSY;
    _allUsers = await _userRepository.fetchUsersWithPagination(endUser, _numberOfPages);
    viewState = AllUserViewState.LOADED;
  }
}
