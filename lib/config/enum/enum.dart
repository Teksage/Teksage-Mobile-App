import 'package:flutter/material.dart';

enum SnackBarPosition {
  top,
  bottom,
}

final Map<String, IconData> snackBarIcons = {
  'success': Icons.check_circle,
  'error': Icons.error,
  'warning': Icons.warning,
  'info': Icons.info,
};
