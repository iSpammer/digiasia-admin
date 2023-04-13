import 'package:flutter/material.dart';

class AnalyticInfo {
  final String? title;
  final IconData? iconSrc;
  final Color? color;
  String? val = "";

  AnalyticInfo({
    required this.iconSrc,
    required this.title,
    required this.color,
    this.val
  });
}

