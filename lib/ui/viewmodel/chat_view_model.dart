import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/user_repository.dart';

enum ChatViewState { IDLE, BUSY }

class ChatViewModel with ChangeNotifier {
  List<MessageModel>? _allMessages;
  ChatViewState _chatViewState = ChatViewState.IDLE;
  UserRepository _userRepository = UserRepository();

  ChatViewState get chatViewState => _chatViewState;

  void fetchMessage(String currentUserID, String chatUserID) {
    _userRepository.fetchMessage(currentUserID, chatUserID).listen((List<MessageModel> messages) {
      _chatViewState = ChatViewState.BUSY;
      _allMessages!.addAll(messages);
    });
  }
}


//GÜNCELLENECEK