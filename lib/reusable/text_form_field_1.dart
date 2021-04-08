import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormField1 extends StatelessWidget {
  final String placeholder;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final bool showPhoneNumberPrefix;
  final Function validator;
  final bool isPhoneNumber;
  final bool isPassword;
  final FocusNode focusNode;
  final Function onNext;
  TextFormField1({
    @required this.placeholder,
    @required this.textInputType,
    @required this.textEditingController,
    @required this.focusNode,
    this.onNext,
    this.isPhoneNumber = false,
    this.showPhoneNumberPrefix = false,
    this.validator,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      keyboardType: this.textInputType,
      inputFormatters: isPhoneNumber ? [
        FilteringTextInputFormatter.digitsOnly,
      ] : [],
      onEditingComplete: onNext == null ? () {} : onNext,
      obscureText: isPassword,
      maxLength: isPhoneNumber ? 10 : 50,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counterText: "",
        labelText: placeholder,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefix: showPhoneNumberPrefix ? Text('+977 ') : SizedBox.shrink(),
        prefixStyle: TextStyle(color: Colors.black),
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withAlpha(80),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      validator: validator == null ? (value) => null : validator,
    );
  }
}