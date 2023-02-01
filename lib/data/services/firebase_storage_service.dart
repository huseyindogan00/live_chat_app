import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:live_chat_app/data/services/interface/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference? _storageReference;

  /// Kaydedilen dosyanın URL linkini geriye döner.
  @override
  Future<String> uploadFile(String userID, StrorageFileEnum fileType, File fileToUpload) async {
    _storageReference = _firebaseStorage
        .ref()
        .child(userID)
        .child(StrorageFileEnum.ProfilePhoto.name)
        .child(fileToUpload.path.substring(fileToUpload.path.lastIndexOf('/')));

    UploadTask uploadTask = _storageReference!.putFile(fileToUpload);

    String url = await _storageReference!.getDownloadURL();

    return url;
  }
}

enum StrorageFileEnum {
  ProfilePhoto,
}
