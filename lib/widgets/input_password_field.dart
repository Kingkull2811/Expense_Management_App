import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPasswordField extends StatelessWidget {
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? hint;
  final TextEditingController controller;
  final onChanged;
  final maxText;
  final whiteList;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? initText;
  final IconData? prefixIcon;
  final onTapSuffixIcon;
  final bool isInputError;
  final validator;

  const InputPasswordField({
    Key? key,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.hint,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.maxText,
    this.whiteList,
    this.obscureText = false,
    this.initText,
    this.prefixIcon,
    this.onTapSuffixIcon,
    this.isInputError = false,
    this.validator,
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

    return TextFormField(
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxText),
        FilteringTextInputFormatter.allow(whiteList ?? RegExp('([\\S])'))
      ],
      style: const TextStyle(
          fontSize: 16, color: Color.fromARGB(255, 26, 26, 26), height: 1.35),
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: InkWell(
          onTap: onTapSuffixIcon,
          child: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
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
          borderSide: BorderSide(
            width: 1,
            color: isInputError
                ? const Color(0xffca0000)
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        hintText: hint,
      ),
    );
  }
}
