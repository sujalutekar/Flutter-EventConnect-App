import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? sufficIconOnPressed;
  final IconData? sufficIcon;
  final TextInputAction textInputAction;
  final int maxLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    required this.obscureText,
    required this.keyboardType,
    this.sufficIconOnPressed,
    this.sufficIcon,
    this.textInputAction = TextInputAction.next,
    this.maxLength = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        maxLength: maxLength,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          counterText: '',
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: sufficIconOnPressed,
                  icon: Icon(
                    sufficIcon,
                    color: Colors.grey,
                  ))
              : null,
        ),
      ),
    );
  }
}
