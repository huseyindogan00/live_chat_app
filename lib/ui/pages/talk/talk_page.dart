import 'package:flutter/material.dart';
import 'package:live_chat_app/data/models/user_model.dart';

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

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    chatUser = widget.chatUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konuşma'),
      ),
      body: Container(
        color: Colors.amber.shade100,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Wrap(
          runSpacing: 10,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildMessageCard(),
                  _buildMessageCard(),
                  _buildMessageCard(),
                  _buildMessageCard(),
                  _buildMessageCard(),
                  _buildMessageCard()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildMessageCard() {
    return Card(
      color: Colors.cyan,
      child: Container(
        padding: EdgeInsets.all(5),
        width: double.infinity,
        child: Wrap(
          runSpacing: 10,
          runAlignment: WrapAlignment.end,
          children: [
            Text(
                'asdasdaspoddlkadam poksappoalmjpokphalskdsapdma p omoflmfsı  km'),
            Text(
                'asdasdaspoddlkadam poksappoalmjpokphalskdsapdma p omoflmfsı  km'),
          ],
        ),
      ),
    );
  }
}
