import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/dialog_action_text.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/components/common/platform_sensitive_alert_dialog.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:live_chat_app/ui/components/common/button/login_button.dart';
import 'package:provider/provider.dart';

class EmailLoginAndRegister extends StatefulWidget {
  const EmailLoginAndRegister({super.key});

  @override
  State<EmailLoginAndRegister> createState() => _EmailLoginAndRegisterState();
}

class _EmailLoginAndRegisterState extends State<EmailLoginAndRegister> {
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  String? _email, _password;
  List<String>? modalBottomResult = [];
  late UserViewModel _userViewModel;

  String? _buttonText, _linkText;
  FormType _formType = FormType.LOGIN;

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);
    _buttonText = _formType == FormType.LOGIN ? 'Giriş Yap' : 'Kayıt Ol';
    _linkText = _formType == FormType.LOGIN ? 'Hesabınız yok mu? Kayıt olun.' : 'Hesabınız var mı? Giriş Yapın.';

    if (_userViewModel.userModel != null) {
      Future.delayed(const Duration(milliseconds: 100), () => Navigator.pop(context));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Email Giriş ve Kayıt')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildFormLogin(_globalFormKey, _formType),
            _buildFormRegister(_formType),
          ],
        ),
      ),
    );
  }

  Form _buildFormLogin(GlobalKey<FormState> key, FormType formType) {
    return Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
            initialValue: 'huseyin03@dgn.com',
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              errorText: _userViewModel.emailErrorMessage.isNotEmpty ? _userViewModel.emailErrorMessage : null,
              prefixIcon: const Icon(Icons.email),
              hintText: 'Email',
              labelText: 'Email',
              border: const OutlineInputBorder(),
            ),
            onSaved: (String? newValue) {
              _email = newValue;
            },
            validator: (String? value) => _userViewModel.emailControl(value),
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: '123456',
            maxLength: 10,
            obscureText: true,
            decoration: InputDecoration(
              errorText: _userViewModel.passwordErrorMessage.isNotEmpty ? _userViewModel.passwordErrorMessage : null,
              prefixIcon: const Icon(Icons.password),
              hintText: 'Şifre',
              labelText: 'Şifre',
              border: const OutlineInputBorder(),
            ),
            onSaved: (String? newValue) {
              _password = newValue;
            },
            validator: (String? value) => _userViewModel.passwordControl(value),
          ),
          const SizedBox(height: 10),
          LoginButton(
            buttonTextWidget: _userViewModel.state == ViewState.Busy
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(_buttonText.toString()),
            buttonIcon: const Icon(Icons.login),
            buttonColor: Colors.green.shade600,
            onPressed: () => _formSubmit(formType),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRegister(FormType formType) {
    return TextButton(
      onPressed: () async {
        setState(() {
          if (_formType == FormType.LOGIN) {
            _formType = FormType.REGISTER;
          } else {
            _formType = FormType.LOGIN;
          }
        });
      },
      child: Text(_linkText!),
    );
  }

  // GİRİŞ BUTONUNA TIKLANDIĞI ZAMAN
  void _formSubmit(FormType formType) async {
    UserModel? entryUser;
    UserModel? createUser;
    if (_globalFormKey.currentState!.validate()) {
      _globalFormKey.currentState!.save();
      if (formType == FormType.LOGIN) {
        entryUser = await _userViewModel.signInWithEmailAndPassword(_email!, _password!);
        if (entryUser == null) {
          // ignore: use_build_context_synchronously
          await const PlatformSensitiveAlertDialog(
            content: 'Kullanıcı bulunamadı ya da şifre yanlış.',
            title: 'Uyarı!',
            doneButtonTitle: DialogActionText.done,
          ).show(context);
        }
      } else {
        createUser = await _userViewModel.createUserWithEmailAndPassword(_email!, _password!);
        if (_formType == FormType.REGISTER && createUser == null) {
          // ignore: use_build_context_synchronously
          await const PlatformSensitiveAlertDialog(
            content: 'Kullanıcı zaten kayıtlı, lütfen giriş yapınız.',
            title: 'Uyarı!',
            doneButtonTitle: DialogActionText.done,
          ).show(context);
        } else {
          _userViewModel.userModel = createUser;
        }
      }
    }
  }
}

enum FormType { REGISTER, LOGIN }
