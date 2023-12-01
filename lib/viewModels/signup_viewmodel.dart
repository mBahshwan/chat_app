import 'package:flutter/material.dart';
import 'package:whatsapp_clone/services/signup_services.dart';

class SignUpViewmodel extends ChangeNotifier {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isHide = true;
  bool _isHide2 = true;

  Future<void> signUpUser(
      String email, String password, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await SignUpServices.signUp(
        email,
        password,
        context,
      );
    }
    notifyListeners();
  }

  void cahngeIcon() {
    _isHide = !_isHide;
    notifyListeners();
  }

  void cahngeIcontwo() {
    _isHide2 = !_isHide2;
    notifyListeners();
  }

  bool get isHide => _isHide;
  bool get isHide2 => _isHide2;
  GlobalKey<FormState> get formKey => _formKey;
}
