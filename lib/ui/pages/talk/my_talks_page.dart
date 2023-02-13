import 'package:flutter/material.dart';

class MyTalksPage extends StatefulWidget {
  const MyTalksPage({super.key});

  @override
  State<MyTalksPage> createState() => _MyTalksPageState();
}

class _MyTalksPageState extends State<MyTalksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sohbetler'),
      ),
      body: Container(
        child: Text('koonuşmalar'),
      ),
    );
  }
}
