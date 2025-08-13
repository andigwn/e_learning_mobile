import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:flutter/material.dart';

class BuildStudentInfoCard extends StatelessWidget {
  final Student student;
  final Rombel rombel;
  final Periode periode;

  const BuildStudentInfoCard({
    super.key,
    required this.student,
    required this.rombel,
    required this.periode,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        final scaleValue = Tween(begin: 0.8, end: 1.0).transform(clampedValue);

        return Transform.translate(
          offset: Offset(0, 50 * (1 - clampedValue)),
          child: Transform.scale(scale: scaleValue, child: child),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF43A680), Color(0xFF2D7A5C)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.shade300,
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'student-avatar-${student.id}',
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(student.imageUrl),
                          onBackgroundImageError:
                              (_, __) =>
                                  const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIS: ${student.nis}',
                            style: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.school, 'Kelas', rombel.nama),
                _buildInfoRow(
                  Icons.class_,
                  'Jurusan',
                  rombel.jurusan['nama_jurusan'],
                ),
                _buildInfoRow(Icons.calendar_today, 'Periode', periode.nama),
                _buildInfoRow(Icons.bar_chart, 'Semester', periode.semester),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
