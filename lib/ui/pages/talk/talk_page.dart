import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/core/utility/global_util.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class TalkPage extends StatefulWidget {
  const TalkPage(
      {super.key, required this.currentUser, required this.chatUser});

  final UserModel currentUser;
  final UserModel chatUser;

  @override
  State<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  late final UserModel currentUser;
  late final UserModel chatUser;
  TextEditingController messageTextFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    chatUser = widget.chatUser;
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUser.userName.toString()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _userViewModel.getMessage(
                  currentUser.userID!, chatUser.userID!),
              builder: (context, AsyncSnapshot<List<MessageModel>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<MessageModel> messages = snapshot.data!;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, int index) {
                      MessageModel message = messages[index];
                      if (message.fromMe) {
                        return _buildCurrentUserMessageText(message);
                      }
                      return _buildChatUserMessageText(message);
                    },
                  );
                }
              },
            ),
          ),
          _buildMessageTextField(_userViewModel),
        ],
      ),
    );
  }

  Widget _buildCurrentUserMessageText(MessageModel message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade200,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(message.message),
          ),
        ],
      ),
    );
  }

  _buildChatUserMessageText(MessageModel message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(message.message),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildMessageTextField(UserViewModel userViewModel) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageTextFieldController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () async {
              if (messageTextFieldController.text.trim().isNotEmpty) {
                MessageModel messageModel = MessageModel(
                  userID: currentUser.userID!,
                  fromWhoID: currentUser.userID!,
                  whoID: chatUser.userID!,
                  fromMe: true,
                  message: messageTextFieldController.text,
                  date: FieldValue.serverTimestamp(),
                );

                messageTextFieldController.clear();

                await userViewModel.saveMessage(messageModel);
              }
            },
            child: const Icon(Icons.navigation_outlined),
          )
        ],
      ),
    );
  }
}
