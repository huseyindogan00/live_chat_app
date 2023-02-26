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
  bool _hasMore = true;
  int _numberOfPages = 3;
  final UserRepository _userRepository = locator<UserRepository>();

  List<UserModel>? get allUsersList => _allUsers;
  AllUserViewState get viewState => _viewState;
  bool get hasMoreLoading => _hasMore;

  set viewState(AllUserViewState value) {
    _viewState = value;
    notifyListeners();
  }

  AllUsersViewModel([this._allUsers, this._endUser]) {
    _allUsers = [];
    _endUser = null;
    fetchUserWithPagination();
  }

  Future<void> fetchUserWithPagination() async {
    viewState = AllUserViewState.BUSY;
    List<UserModel> users = await _userRepository.fetchUsersWithPagination(_endUser, _numberOfPages);
    _allUsers ??= [];
    _hasMore = users.length < _numberOfPages ? false : true;
    _allUsers!.addAll(users);
    _endUser = allUsersList?.last;
    viewState = AllUserViewState.LOADED;
  }

  Future<void> moreUser() async {
    if (_hasMore) {
      await fetchUserWithPagination();
    }
  }

  Future<void> refresh() async {
    _hasMore = true;
    _endUser = null;
    fetchUserWithPagination();
  }
}
