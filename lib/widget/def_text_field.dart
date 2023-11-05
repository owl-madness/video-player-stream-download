import 'package:flutter/material.dart';

class TextFieldDef extends StatelessWidget {
  const TextFieldDef(
      {super.key,
      this.controller,
      this.label,
      this.readOnly,
      this.suffix,
      this.onTap});

  final TextEditingController? controller;
  final String? label;
  final bool? readOnly;
  final Widget? suffix;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 75 / 100,
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        onTap: onTap,
        decoration: InputDecoration(
          suffix: suffix,
          label: Text(label ?? ''),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
