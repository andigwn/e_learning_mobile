import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const MenuCard({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (title) {
      case 'Jadwal Pelajaran':
        icon = Icons.calendar_today;
        break;
      case 'Nilai':
        icon = Icons.grade;
        break;
      case 'E-Book':
        icon = Icons.menu_book;
        break;
      case 'Hasil Studi':
        icon = Icons.assessment;
        break;
      default:
        icon = Icons.help;
    }
    return Card(
      color: Color(0xFF328E6E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
