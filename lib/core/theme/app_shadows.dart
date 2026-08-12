import 'package:flutter/material.dart';

/// Centralized elevation shadows — reach for these instead of a bare `BoxShadow(...)` literal.
abstract final class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}
