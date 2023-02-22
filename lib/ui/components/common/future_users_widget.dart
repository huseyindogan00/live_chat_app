import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/components/common/card/user_card.dart';
import 'package:live_chat_app/ui/viewmodel/all_users_view_model.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class FutureUsersWidget extends StatefulWidget {
  FutureUsersWidget({super.key, required this.userViewModel, this.isTalks = false});
  final UserViewModel userViewModel;
  bool isTalks;

  @override
  State<FutureUsersWidget> createState() => _FutureUsersWidgetState();
}

class _FutureUsersWidgetState extends State<FutureUsersWidget> {
  List<UserModel>? _allUsersModel;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _numberOfPages = 3;
  UserModel? _endUserModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //build methodu tetiklediğinde contextte ihtiyaç duyan methotları burada çalıştırırız
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await fetchUser();
    });
    _buildScrollController();
  }

  void _buildScrollController() {
    _scrollController.addListener(
      () async {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
            _scrollController.position.outOfRange) {
          await fetchUser();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllUsersViewModel>(
      builder: (context, allUserViewModel, child) {
        return allUserViewModel.viewState == AllUserViewState.BUSY
            ? const Center(child: CircularProgressIndicator())
            : allUserViewModel.viewState == AllUserViewState.LOADED
                ? Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: _allUsersModel == null ? const Center(child: Text('kullanıcı yok')) : _buildUserList(),
                      ),
                      _isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
                      Expanded(
                        flex: 2,
                        child: FloatingActionButton(
                          child: const Text('Getir'),
                          onPressed: () async {
                            await fetchUser();
                          },
                        ),
                      ),
                    ],
                  )
                : const Text('busy ve loaded değil');
      },
      /* child: Column(
        children: [
          Expanded(
            flex: 6,
            child: _allUsersModel == null ? const Center(child: Text('kullanıcı yok')) : _buildUserList(),
          ),
          _isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
          Expanded(
            flex: 2,
            child: FloatingActionButton(
              child: const Text('Getir'),
              onPressed: () async {
                await fetchUser();
              },
            ),
          ),
        ],
      ), */
    );
  }

  Future<void> fetchUser() async {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (!_hasMore) {
      return;
    }
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<UserModel> _usersList = await _userViewModel.fetchUsersWithPagination(_endUserModel, _numberOfPages);

    if (_allUsersModel == null) {
      _allUsersModel = [];
      _allUsersModel!.addAll(_usersList);
    } else {
      _allUsersModel!.addAll(_usersList);
    }

    // eğer getirilecek eleman başka yoksa
    if (_usersList.length < _numberOfPages) {
      _hasMore = false;
    }

    _endUserModel = _allUsersModel!.last;

    setState(() {
      _isLoading = false;
    });

    print('gösterilecek başka kullanıcı kalmadı');
    return;
  }

  _buildUserList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _allUsersModel!.length + 1,
      itemBuilder: (context, index) {
        if (index == _allUsersModel!.length) {
          print('liste singlechildscrollview çalıştı');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Opacity(
                opacity: _isLoading ? 1 : 0,
                child: _isLoading ? const SingleChildScrollView() : null,
              ),
            ),
          );
        }
        return UserCard(users: _allUsersModel![index]);
      },
    );
  }
}
