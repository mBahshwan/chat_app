import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObsecure;
  final bool isHide;
  final String hintText;
  final FocusNode focusNode;
  CustomTextFormField({
    super.key,
    required this.hintText,
    required this.isObsecure,
    required this.focusNode,
    required this.isHide,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "this field can't be empty";
          }
          return null;
        },
        onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
        focusNode: focusNode,
        controller: controller,
        cursorColor: textColor,
        obscureText: isObsecure,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: TextStyle(color: textColor), // Placeholder text color
          filled: true,
          fillColor: searchBarColor,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: textColor), // Change the border color here
            borderRadius: BorderRadius.circular(20.0), // Border radius
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Border radius
          ),
          suffixIcon: isHide
              ? InkWell(
                  child: Icon(Icons.remove_red_eye, color: textColor),
                  onTap: () => print("hide"),
                )
              : null,
        ),
      ),
    );
  }
}
