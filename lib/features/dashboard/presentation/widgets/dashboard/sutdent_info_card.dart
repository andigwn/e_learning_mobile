import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:flutter/material.dart';

class BuildStudentInfoCard extends StatelessWidget {
  final Student student;
  const BuildStudentInfoCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF328E6E),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.name!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(student.nis!, style: TextStyle(color: Colors.white)),
            const SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.school, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text('Jurusan', style: TextStyle(color: Colors.white)),
                SizedBox(width: 8),
                Text(
                  student.major!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Icon(Icons.class_, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text('Kelas', style: TextStyle(color: Colors.white)),
                SizedBox(width: 8),
                Text(
                  student.classroom!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            Row(
              children: const [
                Icon(Icons.bar_chart, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Nilai Rata - Rata',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(
                  '85,53',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
