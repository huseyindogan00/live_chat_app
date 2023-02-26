import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  /* List<UserModel>? _allUsersModel;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _numberOfPages = 3;
  UserModel? _endUserModel; */
  final ScrollController _scrollController = ScrollController();
  late AllUsersViewModel allUsersViewModel;

  @override
  void initState() {
    super.initState();
    //build methodu tetiklediğinde contextte ihtiyaç duyan methotları burada çalıştırırız
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      allUsersViewModel = Provider.of<AllUsersViewModel>(context, listen: false);
    });

    _buildScrollController();
  }

  void _buildScrollController() {
    _scrollController.addListener(
      () async {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          //await allUsersViewModel.moreUser();
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
                        child: allUserViewModel.allUsersList == null
                            ? const Center(child: Text('kullanıcı yok'))
                            : _buildUserList(allUserViewModel),
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

  /* Future<void> fetchUser() async {
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
  } */

  Widget _buildUserList(AllUsersViewModel allUserModelList) {
    return RefreshIndicator(
      onRefresh: () async => await allUsersViewModel.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: allUserModelList.allUsersList!.length + 1,
        itemBuilder: (context, index) {
          if (index == allUserModelList.allUsersList!.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: allUserModelList.viewState == ViewState.Idle ? const SingleChildScrollView() : null,
              ),
            );
          }
          return UserCard(users: allUserModelList.allUsersList![index]);
        },
      ),
    );
  }
}
