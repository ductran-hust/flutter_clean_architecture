import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/app_colors.dart';

class SpotifyBottomNav extends StatelessWidget {
  const SpotifyBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isDark = false,
  });
  final int currentIndex;
  final Function(int) onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.white : Colors.black;
    const selectedColor = AppColors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : AppColors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: _HomeIcon(),
            index: 0,
            currentIndex: currentIndex,
            onTap: onTap,
            activeColor: selectedColor,
            inactiveColor: color,
          ),
          _NavItem(
            icon: const Icon(Icons.explore_outlined, size: 26),
            index: 1,
            currentIndex: currentIndex,
            onTap: onTap,
            activeColor: selectedColor,
            inactiveColor: color,
          ),
          _NavItem(
            icon: const Icon(Icons.favorite, size: 26),
            index: 2,
            currentIndex: currentIndex,
            onTap: onTap,
            activeColor: selectedColor,
            inactiveColor: color,
          ),
          _NavItem(
            icon: const Icon(Icons.person_outline, size: 26),
            index: 3,
            currentIndex: currentIndex,
            onTap: onTap,
            activeColor: selectedColor,
            inactiveColor: color,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });
  final Widget icon;
  final int index;
  final int currentIndex;
  final Function(int) onTap;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: ColoredBox(
        color: Colors.transparent,
        child: IconTheme(
          data: IconThemeData(color: isSelected ? activeColor : inactiveColor),
          child: icon,
        ),
      ),
    );
  }
}

class _HomeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(26, 26), painter: _PentagonPainter());
  }
}

class _PentagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final path = Path();
    const n = 5;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2 * 0.9;

    for (int i = 0; i < n; i++) {
      final angle = (i * 2 * 3.14159 / n) - 3.14159 / 2;
      final x = centerX + radius * _cos(angle);
      final y = centerY + radius * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double angle) => angle == 0
      ? 1
      : (angle == 3.14159 ? -1 : (1 - angle * angle / 2 + angle * angle * angle * angle / 24));
  double _sin(double angle) =>
      angle - angle * angle * angle / 6 + angle * angle * angle * angle * angle / 120;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
