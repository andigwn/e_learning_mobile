// widgets/subject_card.dart
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final Jadwal jadwal;
  final VoidCallback? onTap;

  const SubjectCard({super.key, required this.jadwal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF328E6E),
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jadwal.mapel!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    '${jadwal.jamMulai!} - ${jadwal.jamSelesai!}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.room, size: 14, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    jadwal.ruangan!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    jadwal.guru!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
