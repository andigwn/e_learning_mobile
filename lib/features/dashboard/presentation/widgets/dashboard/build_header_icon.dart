import 'package:flutter/material.dart';

class BuildHeaderIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const BuildHeaderIcon({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<BuildHeaderIcon> createState() => _BuildHeaderIconState();
}

class _BuildHeaderIconState extends State<BuildHeaderIcon>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 200);
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 0.2,
      end: 0.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    isHovered ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(_opacityAnimation.value),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(
                          0.4 * _controller.value,
                        ),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 24 * _scaleAnimation.value,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12 + (1 * _controller.value),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 4 * _controller.value,
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
