import 'dart:io';

import 'package:live_chat_app/data/services/firebase_storage_service.dart';

abstract class StorageBase {
  Future<String> uploadFile(String userID, StrorageFileEnum fileType, File fileToUpload);
}
