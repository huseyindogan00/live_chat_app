import 'package:flutter/material.dart';
import 'package:live_chat_app/core/product/constant/dialog_action_text.dart';
import 'package:live_chat_app/ui/components/common/platform_sensitive_alert_dialog.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:live_chat_app/ui/widgets/button/login_button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController controllerUsername;
  late GlobalKey<FormFieldState> textFormKey;

  @override
  void initState() {
    super.initState();
    controllerUsername = TextEditingController();
    textFormKey = GlobalKey<FormFieldState>();
  }

  @override
  void dispose() {
    textFormKey.currentState!.dispose();
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
          IconButton(
            onPressed: () => doExit(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: userViewModel.userModel?.photoUrl == null
                    ? const NetworkImage('https://picsum.photos/200')
                    : NetworkImage(userViewModel.userModel!.photoUrl!),
                radius: 75,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: userViewModel.userModel!.email,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Email adresiniz', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: textFormKey,
                controller: controllerUsername,
                validator: (_) {
                  if (controllerUsername.text.isEmpty) {
                    return 'Username boş olamaz';
                  } else if (userViewModel.userModel!.userName == controllerUsername.text) {
                    return 'Username alanı aynı';
                  }
                  return null;
                },
                readOnly: false,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              LoginButton(
                buttonTextWidget: const Text('Değişikleri Kaydet'),
                buttonColor: Colors.purple,
                onPressed: () async {
                  if (textFormKey.currentState!.validate()) {
                    userViewModel.updateUserName(controllerUsername.text);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> doExit(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);

    bool? result = await const PlatformSensitiveAlertDialog(
      content: 'Oturumu kapatmak istedğinizden emin misiniz?',
      title: 'UYARI!',
      doneButtonTitle: DialogActionText.yes,
      cancelButtonTitle: DialogActionText.cancel,
    ).show(context);

    print(result);

    if (result != null && result) {
      await _userModel.signOut();
    }
  }
}
