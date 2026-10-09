import 'package:flutter/material.dart';
import 'package:Samarpana/utils/text_field_container.dart';
import 'colors.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
