import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/data/model/pengumpulan_tugas_model.dart';
import 'package:e_learning_mobile/utils/url_launcher.dart';

class RiwayatCard extends StatelessWidget {
  final PengumpulanTugas tugas;
  final int index;

  const RiwayatCard({super.key, required this.tugas, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[50]!, Colors.grey[100]!],
          ),
          border: Border(
            left: BorderSide(color: _getStatusColor(tugas.status), width: 6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(DateTime.parse(tugas.tanggalPengumpulan)),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(tugas.status),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      tugas.status,
                      style: TextStyle(
                        color: _getStatusColor(tugas.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Icon(Icons.link, size: 18, color: Colors.teal[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () => launchURL(context, tugas.linkTugas),
                      child: Text(
                        tugas.linkTugas,
                        style: TextStyle(
                          color: Colors.teal[600],
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (tugas.tugas?.judul.isNotEmpty ?? false) ...[
                const Text(
                  'Tugas:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tugas.tugas!.judul,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (tugas.nilai > 0) ...[
                Row(
                  children: [
                    Icon(Icons.grade, size: 18, color: Colors.amber[600]),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Nilai: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextSpan(
                            text: '${tugas.nilai}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              if (tugas.komentar.isNotEmpty) ...[
                const Text(
                  'Komentar Guru:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    tugas.komentar,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Dikumpulkan':
        return Colors.green.shade700;
      case 'Terlambat':
        return Colors.orange.shade700;
      default:
        return Colors.red.shade700;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Dikumpulkan':
        return Colors.green.shade50;
      case 'Terlambat':
        return Colors.orange.shade50;
      default:
        return Colors.red.shade50;
    }
  }
}
