import 'package:flutter/material.dart';
import 'package:peixe_babel/theme/app_theme.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      icon: Icon(icon, size: 22),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
