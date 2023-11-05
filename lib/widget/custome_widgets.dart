import 'package:flutter/material.dart';

class CustomWidgets {
  static showSnackBar(String s, BuildContext context) {
    debugPrint(s);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          s,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget stoppedAnimationProgress({color}) => CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
      );

  static Widget submitButton(String title,
      {void Function()? onTap, Color? bgColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: bgColor ?? Colors.red),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
