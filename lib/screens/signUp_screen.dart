import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/screens/login_screen.dart';
import 'package:whatsapp_clone/viewModels/signup_viewmodel.dart';
import 'package:whatsapp_clone/widgets/customButton.dart';
import 'package:whatsapp_clone/widgets/customTextFormField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasword = TextEditingController();

  FocusNode emailFoucs = FocusNode();
  FocusNode passwordFoucs = FocusNode();
  FocusNode confirmPassword = FocusNode();

  String defaultImage =
      "https://oedit.colorado.gov/sites/coedit/files/styles/contact_crop/public/2020-11/Person%20Icon_12.png?h=87136cbf";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Form(
          key: Provider.of<SignUpViewmodel>(context, listen: false).formKey,
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
                      CircleAvatar(
                        backgroundColor: backgroundColor,
                        radius: 70,
                        backgroundImage: NetworkImage(defaultImage),
                      ),
                      Text(
                        "Sign up",
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
                  // CustomTextFormField(
                  //   focusNode: passwordFoucs,
                  //   controller: passwordController,
                  //   isHide: true,
                  //   isObsecure: true,
                  //   hintText: "Enter Your Password",
                  // ),
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
                      obscureText: Provider.of<SignUpViewmodel>(context).isHide,
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
                          child: Provider.of<SignUpViewmodel>(context).isHide
                              ? Icon(Icons.remove_red_eye, color: textColor)
                              : Icon(Icons.remove_red_eye_outlined,
                                  color: textColor),
                          onTap: () => Provider.of<SignUpViewmodel>(context,
                                  listen: false)
                              .cahngeIcon(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "this field can't be empty";
                        } else if (value != passwordController.text) {
                          return "password does not match";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).unfocus(),
                      focusNode: confirmPassword,
                      controller: confirmPasword,
                      cursorColor: textColor,
                      obscureText:
                          Provider.of<SignUpViewmodel>(context).isHide2,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "confirm password",

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
                          child: Provider.of<SignUpViewmodel>(context).isHide2
                              ? Icon(Icons.remove_red_eye, color: textColor)
                              : Icon(Icons.remove_red_eye_outlined,
                                  color: textColor),
                          onTap: () => Provider.of<SignUpViewmodel>(context,
                                  listen: false)
                              .cahngeIcontwo(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CustomButton(
                        text: "Sign up",
                        onPressed: () async {
                          Provider.of<SignUpViewmodel>(context, listen: false)
                              .signUpUser(emailController.text,
                                  passwordController.text, context);
                        }),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  InkWell(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false),
                    child: Text(
                      "if you already have an account? Login",
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
