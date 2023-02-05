import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
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
  late final UserModel currentUser;
  late final UserModel chatUser;
  TextEditingController messageTextFieldController = TextEditingController();

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
        title: Text(_userViewModel.userModel!.userName.toString()),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.amber.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildMessageCard(_userViewModel),
            _buildMessageLine(_userViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(UserViewModel userViewModel) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: StreamBuilder<List<MessageModel>>(
          stream: userViewModel.getMessage(currentUser.userID!, chatUser.userID!),
          builder: (context, AsyncSnapshot<List<MessageModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<MessageModel> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                MessageModel message = messages[index];
                return message.fromMe ? _buildCurrentUserMessageText(message) : _buildChatUserMessageText(message);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentUserMessageText(MessageModel message) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(message.message),
      ),
    );
  }

  _buildChatUserMessageText(MessageModel message) {}

  Container _buildMessageLine(UserViewModel userViewModel) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
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
                );

                messageTextFieldController.clear();

                bool result = await userViewModel.saveMessage(messageModel);
              }
            },
            child: const Icon(Icons.navigation_outlined),
          )
        ],
      ),
    );
  }
}
