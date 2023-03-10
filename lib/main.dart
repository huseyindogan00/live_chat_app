import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/ui/pages/home/home_screen.dart';
import 'package:live_chat_app/ui/pages/start/splash_screen.dart';
import 'package:live_chat_app/ui/viewmodel/all_users_view_model.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // başlatıldığından emin ol
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      firebaseMessage); // uygulama arka planda çalıştığında data mesajlarımı alabilmek için
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AllUsersViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
