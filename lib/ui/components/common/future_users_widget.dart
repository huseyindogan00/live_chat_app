import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/pages/talk/talk_page.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class FutureUsersWidget extends StatefulWidget {
  FutureUsersWidget(
      {super.key, required this.userViewModel, this.isTalks = false});
  final UserViewModel userViewModel;
  bool isTalks;

  @override
  State<FutureUsersWidget> createState() => _FutureUsersWidgetState();
}

class _FutureUsersWidgetState extends State<FutureUsersWidget> {
  List<UserModel> _allUsersModel = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _pageCount = 5;
  UserModel? _endUserModel;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.atEdge) {
          print('kenarda');
          if (_scrollController.position == 0) {
            print('liste başta');
          } else {
            fetchUser(_endUserModel);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    return Column(
      children: [
        Expanded(
          child: _allUsersModel.isEmpty
              ? const Center(child: Text('kullanıcı yok'))
              : _buildUserList(),
        ),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(),
        Expanded(
          child: FloatingActionButton(
            child: const Text('Getir'),
            onPressed: () {
              fetchUser(_endUserModel);
            },
          ),
        ),
      ],
    );
  }

  fetchUser(UserModel? endUserModel) async {
    setState(() {
      _isLoading = true;
    });

    var firebase = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot;
    if (endUserModel == null) {
      snapshot =
          await firebase.collection('users').orderBy('userName').limit(3).get();
    } else {
      snapshot = await firebase
          .collection('users')
          .orderBy('userName')
          .startAfter([endUserModel.userName])
          .limit(3)
          .get();
    }

    for (var data in snapshot.docs) {
      _allUsersModel.add(UserModel.fromMap(data.data()));
    }

    _endUserModel = _allUsersModel.last;

    setState(() {
      _isLoading = false;
    });
  }

  _buildUserList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _allUsersModel.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_allUsersModel[index].userName.toString()),
        );
      },
    );
  }
}
