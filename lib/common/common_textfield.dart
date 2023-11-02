import 'package:flutter/material.dart';

class CommonTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Future<void> Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final bool isPassword;
  final AutovalidateMode? autovalidateMode;
  final Icon? prefixIcon;
  final Widget? dropDown;
  final EdgeInsetsGeometry? contentPadding;
  const CommonTextFormField(
      {super.key,
      this.contentPadding,
      required this.hintText,
      this.controller,
      this.obscureText,
      this.keyboardType,
      this.validator,
      this.onChanged,
      this.onTap,
      this.readOnly,
      required this.textInputAction,
      this.isPassword = false,
      this.autovalidateMode,
      this.prefixIcon,
      this.dropDown});

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
          ),
        ),
        suffixIcon: widget.isPassword && widget.obscureText != null
            ? IconButton(
                icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(
                    () {
                      passwordVisible = !passwordVisible;
                    },
                  );
                },
              )
            : null,
      ),
      obscureText: widget.isPassword ? !passwordVisible : false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      textInputAction: widget.textInputAction,
      autovalidateMode:
          widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
    );
  }
}
