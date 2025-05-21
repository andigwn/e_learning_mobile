import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/build_header_icon.dart';
import 'package:flutter/material.dart';

class BuildHeaderLogo extends StatefulWidget {
  const BuildHeaderLogo({super.key});

  @override
  State<BuildHeaderLogo> createState() => _BuildHeaderLogoState();
}

class _BuildHeaderLogoState extends State<BuildHeaderLogo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Color(0xFF328E6E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Image.asset("assets/images/background.jpg"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Logo sekolah/kampus
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.school, size: 40, color: Colors.blue);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Nama institusi
                const Text(
                  'SMK Negeri 5 Pontianak',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),

                // Baris icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BuildHeaderIcon(icon: Icons.notifications, label: 'Notif'),
                    BuildHeaderIcon(icon: Icons.message, label: 'Pesan'),
                    BuildHeaderIcon(icon: Icons.settings, label: 'Pengaturan'),
                    BuildHeaderIcon(icon: Icons.help, label: 'Bantuan'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
