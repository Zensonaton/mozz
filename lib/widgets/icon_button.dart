import "package:flutter/material.dart";

/// Виджет, репрезентирующий кнопку с иконкой.
class CustomIconButton extends StatelessWidget {
  /// Виджет, используемый как иконка.
  final Widget icon;

  /// Callback-метод, вызываемый при нажатии на кнопку.
  final VoidCallback? onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFEDF2F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
