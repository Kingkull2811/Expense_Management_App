import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final Function(String)? onSubmit;
  final TextInputAction textInputAction;
  final String? hint;
  final TextEditingController controller;
  final onChanged;
  final maxText;
  final whiteList;
  final TextInputType? keyboardType;
  final String? initText;
  final IconData? prefixIcon;
  final bool isInputError;

  const Input({
    Key? key,
    this.onSubmit,
    required this.textInputAction,
    this.hint,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.maxText,
    this.whiteList,
    this.initText,
    this.prefixIcon,
    this.isInputError = false,
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

    return  TextField(
            textInputAction: textInputAction,
            onSubmitted: onSubmit,
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxText),
              FilteringTextInputFormatter.allow(whiteList ?? RegExp('([\\S])'))
            ],
            style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 26, 26, 26),
                height: 1.35),
            decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                size: 24,
                 color: Theme.of(context).colorScheme.primary,
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
                borderSide:  BorderSide(
                  width: 1,
                  color:  isInputError
                      ? const Color(0xffca0000)
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              hintText: hint,
            ),
          );
  }
}
