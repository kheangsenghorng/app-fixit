import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        onChanged: widget.onChanged,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction, // 🔥 instant validation
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            widget.icon,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            size: 20,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            onPressed: () {
              setState(() => _obscureText = !_obscureText);
            },
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
