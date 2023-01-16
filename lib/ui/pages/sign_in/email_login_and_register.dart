import 'package:flutter/material.dart';
import 'package:live_chat_app/ui/pages/sign_in/sign_in_screen.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:live_chat_app/ui/widgets/button/login_button.dart';
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

  Form _buildFormLogin(GlobalKey<FormState> key, FormType formType) {
    //print(_userViewModel.state);
    return Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
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

  // GİRİŞ BUTONUNA TIKLANDIĞI ZAMAN
  void _formSubmit(FormType formType) async {
    UserModel? entryUser;
    UserModel? createUser;
    if (_globalFormKey.currentState!.validate()) {
      _globalFormKey.currentState!.save();
      if (formType == FormType.LOGIN) {
        entryUser = await _userViewModel.signInWithEmailAndPassword(_email!, _password!);
        if (_formType == FormType.LOGIN && entryUser == null) {
          _buildShowDialog('Kullanıcı bulunamadı');
        }
      } else {
        createUser = await _userViewModel.crateUserWithEmailAndPassword(_email!, _password!);
        if (_formType == FormType.REGISTER && createUser == null) {
          _buildShowDialog('Kullanıcı zaten kayıtlı');
        }
      }
    }
  }

  Future<void> _buildShowDialog(String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Uyarı !'),
            subtitle: Text(message),
            trailing: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.done)),
          ),
        );
      },
    );
  }
}

enum FormType { REGISTER, LOGIN }
