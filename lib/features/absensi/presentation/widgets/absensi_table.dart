// lib/features/absensi/presentation/widgets/absensi_table.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_learning_mobile/features/absensi/data/model/absensi_model.dart';

class AbsensiTable extends StatelessWidget {
  final List<Absensi> absensiList;

  const AbsensiTable({super.key, required this.absensiList});

  String _formatDate(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'izin':
        return Colors.orange;
      case 'sakit':
        return Colors.blue;
      case 'alpa':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getVerifikasiColor(String verifikasi) {
    switch (verifikasi.toLowerCase()) {
      case 'tepatwaktu':
        return Colors.green;
      case 'terlambat':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (absensiList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'Belum ada data absensi',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DataTable(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            headingRowColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) => Colors.green[50]!,
            ),
            columnSpacing: 24,
            columns: [
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Tanggal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Pertemuan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Verifikasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Ruangan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ),
            ],
            rows:
                absensiList.map((absensi) {
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color>((
                      Set<WidgetState> states,
                    ) {
                      return absensiList.indexOf(absensi) % 2 == 0
                          ? Colors.grey[50]!
                          : Colors.white;
                    }),
                    cells: [
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _formatDate(absensi.tanggal),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            absensi.pertemuan.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(absensi.status),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              absensi.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            absensi.verifikasiAbsensi,
                            style: TextStyle(
                              color: _getVerifikasiColor(
                                absensi.verifikasiAbsensi,
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            absensi.ruangan,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
