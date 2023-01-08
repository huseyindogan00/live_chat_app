import 'package:get_it/get_it.dart';
import 'package:live_chat_app/data/user_repository.dart';
import 'package:live_chat_app/data/services/fake_auth_service.dart';
import 'package:live_chat_app/data/services/firebase_auth_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService()); // İhtiyaç halinde nesne oluşturulur
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
}
