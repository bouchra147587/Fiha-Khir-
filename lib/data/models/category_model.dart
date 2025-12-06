import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;

  const Category({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
  });

  @override
  List<Object?> get props => [title, subtitle, icon, bgColor];
}


