import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/signUp_screen.dart';
import 'package:whatsapp_clone/viewModels/login_viewmodel.dart';
import 'package:whatsapp_clone/widgets/customButton.dart';
import 'package:whatsapp_clone/widgets/customTextFormField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFoucs = FocusNode();
  FocusNode passwordFoucs = FocusNode();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Form(
          key: Provider.of<LoginViewmodel>(context).formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: backgroundColor,
                        radius: 70,
                        backgroundImage: NetworkImage(
                            "https://oedit.colorado.gov/sites/coedit/files/styles/contact_crop/public/2020-11/Person%20Icon_12.png?h=87136cbf"),
                      ),
                      Text(
                        "login",
                        style: TextStyle(color: textColor, fontSize: 20),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  CustomTextFormField(
                    focusNode: emailFoucs,
                    controller: emailController,
                    isHide: false,
                    isObsecure: false,
                    hintText: "Enter Your Email",
                  ),
                  SizedBox(
                    height: size.height * 0.001,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "this field can't be empty";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).unfocus(),
                      focusNode: passwordFoucs,
                      controller: passwordController,
                      cursorColor: textColor,
                      obscureText: Provider.of<LoginViewmodel>(context).isHide,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Enter Your Password",

                        hintStyle: TextStyle(
                            color: textColor), // Placeholder text color
                        filled: true,
                        fillColor: searchBarColor,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: textColor), // Change the border color here
                          borderRadius:
                              BorderRadius.circular(20.0), // Border radius
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Border radius
                        ),
                        suffixIcon: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Provider.of<LoginViewmodel>(context).isHide
                              ? Icon(Icons.remove_red_eye, color: textColor)
                              : Icon(Icons.remove_red_eye_outlined,
                                  color: textColor),
                          onTap: () => Provider.of<LoginViewmodel>(context,
                                  listen: false)
                              .cahngeIcon(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "login",
                      onPressed: () async {
                        UserModel userModel = UserModel(
                            token: "",
                            name: "",
                            password: passwordController.text,
                            email: emailController.text,
                            isOnline: false,
                            image: "",
                            date: Timestamp.fromDate(DateTime.now()),
                            uid: "");
                        sharedPreferences!.setBool("editComplete", false);
                        LoginViewmodel.userLogin(userModel, context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  InkWell(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                        (route) => false),
                    child: Text(
                      "if you don't have an account? Sign up",
                      style: TextStyle(color: textColor, fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
