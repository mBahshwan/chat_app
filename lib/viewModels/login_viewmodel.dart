import 'package:flutter/material.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/services/login_services.dart';

class LoginViewmodel extends ChangeNotifier {
  bool _isHide = true;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static Future<void> userLogin(
      UserModel userModel, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await LoginServices.loginWithEmailPassword(userModel, context);
      sharedPreferences!.setBool("editComplete", false);
    }
  }

  void cahngeIcon() {
    _isHide = !_isHide;
    notifyListeners();
  }

  bool get isHide => _isHide;

  GlobalKey<FormState> get formKey => _formKey;
}
