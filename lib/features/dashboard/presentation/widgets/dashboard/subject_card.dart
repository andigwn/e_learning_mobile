import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final Jadwal jadwal;
  final VoidCallback onTap;

  const SubjectCard({super.key, required this.jadwal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jadwal.guruMapel.mapel['nama_mapel'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${jadwal.jamMulai} - ${jadwal.jamSelesai}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      jadwal.guruMapel.guru['nama'],
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
