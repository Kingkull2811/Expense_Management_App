
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final bool useCupertinoTextField;
  final FocusNode? focusNode;
  final onSubmit;
  final TextInputAction textInputAction;
  final String? hint;
  final TextEditingController controller;
  final onChanged;
  final maxText;
  final whiteList;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? initText;
  //final String? suffixIconPath;
  final Icon? prefixIcon;
  final String? prefixIconPath;
  //final Function()? onShowPassword;

  const Input({
    Key? key,
    this.useCupertinoTextField = false,
    this.focusNode,
    this.onSubmit,
    required this.textInputAction,
    this.hint,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.maxText,
    this.whiteList,
    this.obscureText = false,
    this.initText,
    //this.suffixIconPath,
    this.prefixIcon,
    this.prefixIconPath,
    //this.onShowPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initText != null) {
      controller.text = initText!;
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: initText!.length,
      );
    }

    return useCupertinoTextField
        ? CupertinoTextField(
            focusNode: focusNode,
            textInputAction: textInputAction,
            onSubmitted: onSubmit,
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: [LengthLimitingTextInputFormatter(maxText)],
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 26, 26, 26),
              height: 1.35,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromARGB(102, 230, 230, 230),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            prefix: (prefixIconPath != null)
                ? Image.asset(
                    (prefixIconPath!),
                    height: 24,
                    width: 24,
                  )
                : prefixIcon,
            placeholder: hint,
            maxLines: 1,
          )
        : TextField(
            focusNode: focusNode,
            textInputAction: textInputAction,
            onSubmitted: onSubmit,
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxText),
              FilteringTextInputFormatter.allow(whiteList ?? RegExp('([\\S])'))
            ],
            style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 26, 26, 26),
                height: 1.35),
            decoration: InputDecoration(
              prefixIcon: (prefixIconPath != null)
                  ? Image.asset(
                      (prefixIconPath!),
                      height: 24,
                      width: 24,
                    )
                  : prefixIcon,
              prefixIconColor: const Color.fromARGB(102, 230, 230, 230),
              contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              filled: true,
              fillColor: const Color.fromARGB(102, 230, 230, 230),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(128, 130, 130, 130),
                ),
              ),
              hintText: hint,
            ),
          );
  }
}
