import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat_app/core/constant/dialog_action_text.dart';
import 'package:live_chat_app/data/services/firebase_storage_service.dart';
import 'package:live_chat_app/ui/components/common/loading_widget.dart';
import 'package:live_chat_app/ui/components/common/platform_sensitive_alert_dialog.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:live_chat_app/ui/components/common/button/login_button.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController controllerUsername;
  late GlobalKey<FormFieldState> textFormKey;
  XFile? _profilePhoto;

  @override
  void initState() {
    super.initState();
    controllerUsername = TextEditingController();
    textFormKey = GlobalKey<FormFieldState>();
  }

  @override
  void dispose() {
    controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    controllerUsername.text = userViewModel.userModel!.userName!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          _buildExitIconButton(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfilePhoto(userViewModel),
              const SizedBox(height: 20),
              _buildTextFormEmail(userViewModel),
              const SizedBox(height: 20),
              _buildTextFormUserName(userViewModel),
              const SizedBox(height: 20),
              _buildChangeRegisterButton(userViewModel, context)
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildExitIconButton(BuildContext context) {
    return IconButton(
      onPressed: () => doExit(context),
      icon: const Icon(Icons.logout),
    );
  }

  Widget _buildProfilePhoto(UserViewModel userViewModel) {
    return Stack(
      children: [
        _profilePhoto == null
            ? CircleAvatar(
                backgroundImage: userViewModel.userModel?.photoUrl == null
                    ? const NetworkImage('https://picsum.photos/200')
                    : NetworkImage(userViewModel.userModel!.photoUrl!),
                radius: 75,
              )
            : CircleAvatar(
                backgroundImage: FileImage(File(_profilePhoto!.path)),
                radius: 75,
              ),
        Positioned(
          right: -13,
          top: -13,
          child: IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Kameradan çek'),
                          onTap: () {
                            _buildTakePhoto();
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Galeriden getir'),
                          onTap: () {
                            _buildGetGallery();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  _buildGetGallery() async {
    XFile? newProfilePhoto = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePhoto = newProfilePhoto;
    });
  }

  _buildTakePhoto() async {
    var newProfilePhoto = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _profilePhoto = newProfilePhoto;
    });
  }

  TextFormField _buildTextFormEmail(UserViewModel userViewModel) {
    return TextFormField(
      initialValue: userViewModel.userModel!.email,
      readOnly: true,
      decoration: const InputDecoration(labelText: 'Email adresiniz', border: OutlineInputBorder()),
    );
  }

  TextFormField _buildTextFormUserName(UserViewModel userViewModel) {
    return TextFormField(
      key: textFormKey,
      controller: controllerUsername,
      validator: (_) {
        if (controllerUsername.text.isEmpty) {
          return 'Username boş olamaz';
        }
        return null;
      },
      readOnly: false,
      decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
    );
  }

  LoginButton _buildChangeRegisterButton(UserViewModel userViewModel, BuildContext context) {
    return LoginButton(
      buttonTextWidget: const Text('Değişikleri Kaydet'),
      buttonColor: Colors.purple,
      onPressed: () async => await _buildSaveChangeButton(userViewModel, context),
    );
  }

  Future<void> _buildSaveChangeButton(UserViewModel userViewModel, BuildContext context) async {
    bool? isUrlSave;
    bool? isUserNameSave;

    try {
      if (textFormKey.currentState!.validate()) {
        isUserNameSave = await userViewModel.updateUserName(userViewModel.userModel!.userID!, controllerUsername.text);
        if (_profilePhoto != null) {
          isUrlSave = await userViewModel.uploadFile(
              userViewModel.userModel!.userID, StrorageFileEnum.ProfilePhoto, File(_profilePhoto!.path));
        }
      }
      // ignore: use_build_context_synchronously
      PlatformSensitiveAlertDialog(
        content: (isUrlSave ?? false || isUserNameSave!)
            ? 'Kullanıcı güncelleme işlemleri başarılı.'
            : 'Güncelleme başarısız.',
        title: 'Bilgi',
        doneButtonTitle: DialogActionText.done,
      ).show(context);
    } on FirebaseException catch (e) {
      PlatformSensitiveAlertDialog(
        content: 'Kaydetme işlemi başarısız oldu.\n\n-> ${e.message}',
        title: 'Hata',
        doneButtonTitle: DialogActionText.done,
      ).show(context);
    }
  }

  Future<void> doExit(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);

    bool? result = await const PlatformSensitiveAlertDialog(
      content: 'Oturumu kapatmak istedğinizden emin misiniz?',
      title: 'UYARI!',
      doneButtonTitle: DialogActionText.yes,
      cancelButtonTitle: DialogActionText.cancel,
    ).show(context);

    if (result != null && result) {
      await _userModel.signOut();
    }
  }
}
