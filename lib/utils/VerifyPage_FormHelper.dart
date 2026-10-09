import 'package:flutter/material.dart';

class FormHelper {
  static Widget textInput(
    BuildContext context,
    Object initialValue,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    obscureText = false,
    required Function onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
    required String hintText,
    TextStyle? hintStyle,
    TextAlign? textAlign,
    TextEditingController? controller,
  }) {
    return TextFormField(
      initialValue: initialValue.toString(),
      decoration: fieldDecoration(
        context,
        hintText,
        "",
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        textAlign: textAlign,
      ),
      obscureText: obscureText,
      maxLines: !isTextArea ? 1 : 2,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      onChanged: (String value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextStyle? hintStyle,
    TextAlign? textAlign,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: hintStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      errorStyle: TextStyle(color: Colors.red),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        labelName,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget fieldLabelValue(BuildContext context, String labelname) {
    return FormHelper.textInput(
      context, labelname, (value) => {},
      hintText: '',
      onValidate: (value) {
        return null;
      },
      // readOnly: false,
    );
  }

  static Widget saveButton(String buttonText, Function onTap,
      {String? color, String? textColor, bool? fullWidth}) {
    return Container(
      height: 50.0,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.redAccent,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Color.fromRGBO(255, 95, 167, 1),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget cancelButton(String buttonText, Function onTap,
      {String? color, String? textColor, bool? fullWidth}) {
    return Container(
      height: 50.0,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.greenAccent,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: [
            TextButton(
              onPressed: () {
                return onPressed();
              },
              child: Text(buttonText),
            )
          ],
        );
      },
    );
  }
}
