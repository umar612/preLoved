import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<String> onCategorySelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => onCategorySelected(label),
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : Colors.grey[200],
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
      ),
    );
  }
}