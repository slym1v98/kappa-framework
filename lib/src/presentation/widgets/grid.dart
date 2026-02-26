import 'package:flutter/material.dart';

class KappaRow extends StatelessWidget {
  final List<KappaCol> children;
  final double spacing;
  final double runSpacing;

  const KappaRow({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: spacing, runSpacing: runSpacing, children: children);
  }
}

class KappaCol extends StatelessWidget {
  final int xs; // Mobile
  final int? md; // Tablet
  final int? lg; // Desktop
  final Widget child;

  const KappaCol({
    super.key,
    this.xs = 12,
    this.md,
    this.lg,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = MediaQuery.of(context).size.width;
        int columns = xs;

        if (width >= 1024) {
          columns = lg ?? md ?? xs;
        } else if (width >= 768) {
          columns = md ?? xs;
        }

        // Giả định grid 12 cột. Trừ đi spacing của Wrap (spacing * (12/columns - 1) / (12/columns)?)
        // Để đơn giản, ta tính tỉ lệ phần trăm.
        double factor = columns / 12;
        double parentWidth = constraints.maxWidth;

        return SizedBox(
          width:
              (parentWidth * factor) -
              (columns < 12
                  ? 8
                  : 0), // Trừ một chút padding nếu không full width
          child: child,
        );
      },
    );
  }
}
