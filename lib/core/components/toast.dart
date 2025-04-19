import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required BuildContext context,
  required String title,
  required String description,
  ToastificationType type = ToastificationType.success,
  IconData icon = Icons.check,
  Color primaryColor = Colors.green,
  Color backgroundColor = Colors.white,
  Color foregroundColor = Colors.black,
  Duration autoCloseDuration = const Duration(seconds: 5),
}) {
  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: autoCloseDuration,
    title: Text(title),
    description: RichText(
      text: TextSpan(text: description, style: TextStyle(color: Colors.white)),
    ),
    alignment: Alignment.topRight,
    animationDuration: const Duration(milliseconds: 300),
    icon: Icon(icon),
    showIcon: true,
    primaryColor: primaryColor,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    showProgressBar: true,
    closeButton: ToastCloseButton(
      showType: CloseButtonShowType.onHover,
      buttonBuilder: (context, onClose) {
        return OutlinedButton.icon(
          onPressed: onClose,
          icon: const Icon(Icons.close, size: 20),
          label: const Text('Close'),
        );
      },
    ),
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap:
          (toastItem) => print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted:
          (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}
