import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/view/screens/splash_screen.dart';
import 'package:live_chat_app/provider/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ChangeNotifierProvider(
        create: (context) => UserViewModel(),
        child: const SplashScreen(),
      ),
    );
  }
}
