import 'package:flutter/material.dart';

class HariTabBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  HariTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  State<HariTabBar> createState() => _HariTabBarState();
}

class _HariTabBarState extends State<HariTabBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: List.generate(widget.days.length, (index) {
            final isSelected = index == widget.selectedIndex;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    gradient:
                        isSelected
                            ? const LinearGradient(
                              colors: [Color(0xFF328E6E), Color(0xFF1A5D46)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                            : null,
                    color:
                        isSelected
                            ? null
                            : theme.colorScheme.surfaceContainerHighest
                            // ignore: deprecated_member_use
                            .withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.teal.shade300.withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => widget.onTabChanged(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : theme.primaryColor,
                            ),
                            child: Text(widget.days[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
