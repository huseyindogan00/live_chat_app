import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcılar'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const ExamplePage1(),
                  ),
                );
              },
              icon: const Icon(Icons.title))
        ],
      ),
      body: const Center(
        child: Text('Kullanıcılar sayfası'),
      ),
    );
  }
}

class ExamplePage1 extends StatelessWidget {
  const ExamplePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Örnek Sayfa 1'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const ExamplePage2(),
                  ),
                );
              },
              icon: const Icon(Icons.title))
        ],
      ),
      body: const Text('Örnek Page 1'),
    );
  }
}

class ExamplePage2 extends StatelessWidget {
  const ExamplePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Örnek Sayfa 2'),
      ),
      body: const Text('Örnek Page 2'),
    );
  }
}
