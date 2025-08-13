import 'package:flutter/material.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.5, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          final clampedValue = value.clamp(0.5, 1.0);
          return Transform.scale(
            scale: clampedValue,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              backgroundColor: const Color.fromRGBO(224, 242, 241, 1),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
            ),
          );
        },
      ),
    );
  }
}
