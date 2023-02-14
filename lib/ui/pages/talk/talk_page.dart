import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
import 'package:live_chat_app/core/utility/global_util.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class TalkPage extends StatefulWidget {
  const TalkPage({super.key, required this.currentUser, required this.chatUser});

  final UserModel currentUser;
  final UserModel chatUser;

  @override
  State<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  TextStyle timeTextStyle = TextStyle(color: Colors.grey.shade500);
  SizedBox rowTimeAndMessageSizedBox = const SizedBox(width: 10);

  late final UserModel currentUser;
  late final UserModel chatUser;
  TextEditingController messageTextFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  //int isCurrentMessageMoreThenOne = 0;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    chatUser = widget.chatUser;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messageTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUser.userName.toString()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: _userViewModel.fetchMessage(currentUser.userID!, chatUser.userID!),
                builder: (context, AsyncSnapshot<List<MessageModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<MessageModel> messages = snapshot.data!;
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, int index) {
                        MessageModel message = messages[index];

                        if (message.fromMe) {
                          return _buildCurrentUserMessageText(message);
                        }
                        return _buildChatUserMessageText(message, _userViewModel);
                      },
                    );
                  }
                },
              ),
            ),
            _buildMessageTextField(_userViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentUserMessageText(MessageModel message) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            rowTimeAndMessageSizedBox,
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
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(message.message),
            ),
            rowTimeAndMessageSizedBox,
            Text(
              getDateTimeMessageFormat(message.date).split(' ').first,
              style: timeTextStyle,
            )
          ],
        ),
      ],
    );
  }

  _buildChatUserMessageText(MessageModel message, UserViewModel userViewModel) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: _buildChatUserProfilPhoto(),
              maxRadius: 20,
            ),
            rowTimeAndMessageSizedBox,
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(10),
                child: Text(message.message),
              ),
            ),
            rowTimeAndMessageSizedBox,
            Text(
              getDateTimeMessageFormat(message.date).split(' ').first,
              style: timeTextStyle,
            )
          ],
        ),
      ],
    );
  }

  ImageProvider<Object>? _buildChatUserProfilPhoto() {
    if (chatUser.photoUrl != null) {
      return NetworkImage(chatUser.photoUrl!);
    }
    return ExactAssetImage(ImageConstPath.defaultProfilePhoto);
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
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.bounceInOut,
                );

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
