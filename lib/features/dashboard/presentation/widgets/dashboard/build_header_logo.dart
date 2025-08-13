import 'package:flutter/material.dart';

class BuildHeaderLogo extends StatelessWidget {
  const BuildHeaderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final logoSize = isSmallScreen ? 80.0 : 100.0;
        final padding = isSmallScreen ? 12.0 : 16.0;

        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDarkMode
                        ? [const Color(0xFF1A5D46), const Color(0xFF0D3B2A)]
                        : [const Color(0xFF328E6E), const Color(0xFF1A5D46)],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode ? Colors.teal.shade800 : Colors.teal.shade300,
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background image
                _buildBackgroundImage(isSmallScreen),

                // Content
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      _buildLogo(logoSize),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundImage(bool isSmallScreen) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: 1,
      child: Image.asset(
        "assets/images/background.jpg",
        fit: BoxFit.cover,
        width: double.infinity,
        height: isSmallScreen ? 180 : 200,
        errorBuilder:
            (context, error, stackTrace) =>
                Container(color: Colors.teal.shade700),
      ),
    );
  }

  Widget _buildLogo(double size) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.teal.shade700,
                child: const Icon(Icons.school, size: 40, color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
