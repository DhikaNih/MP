// lib/priority_helper.dart
// Utilitas warna prioritas dan parsing hex

import 'package:flutter/material.dart';

class PriorityHelper {
  // Warna label badge
  static Color labelColor(String priority) {
    switch (priority) {
      case 'Penting':
        return const Color(0xFFDC2626);
      case 'Sedang':
        return const Color(0xFFD97706);
      case 'Rendah':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF666666);
    }
  }

  // Warna background badge
  static Color labelBg(String priority) {
    switch (priority) {
      case 'Penting':
        return const Color(0xFFFEE2E2);
      case 'Sedang':
        return const Color(0xFFFEF3C7);
      case 'Rendah':
        return const Color(0xFFD1FAE5);
      default:
        return const Color(0xFFF0F0F0);
    }
  }

  // Warna background icon default per prioritas
  static String defaultIconBg(String priority) {
    switch (priority) {
      case 'Penting':
        return '#FEE2E2';
      case 'Sedang':
        return '#FEF3C7';
      case 'Rendah':
        return '#D1FAE5';
      default:
        return '#F0F0F0';
    }
  }
}

// Parse string hex warna '#RRGGBB' atau '#AARRGGBB' ke Color
Color hexToColor(String hex) {
  final h = hex.replaceAll('#', '');
  if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
  if (h.length == 8) return Color(int.parse(h, radix: 16));
  return Colors.grey.shade100;
}
