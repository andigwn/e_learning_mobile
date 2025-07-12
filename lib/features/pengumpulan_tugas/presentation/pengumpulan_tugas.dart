import 'package:e_learning_mobile/features/pengumpulan_tugas/domain/repository/pengumpulan_tugas_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/bloc/pengumpulan_tugas_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/data/model/pengumpulan_tugas_model.dart';
import 'package:intl/intl.dart';

class PengumpulanTugasPage extends StatefulWidget {
  final int siswaId;
  final int tugasId;

  const PengumpulanTugasPage({
    super.key,
    required this.siswaId,
    required this.tugasId,
  });

  @override
  State<PengumpulanTugasPage> createState() => _PengumpulanTugasPageState();
}

class _PengumpulanTugasPageState extends State<PengumpulanTugasPage> {
  final _linkController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              PengumpulanTugasBloc(context.read<PengumpulanTugasRepository>())
                ..add(
                  LoadPengumpulanTugas(
                    siswaId: widget.siswaId,
                    tugasId: widget.tugasId,
                  ),
                ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengumpulan Tugas'),
          backgroundColor: const Color(0xFF328E6E),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link Tugas',
                  hintText: 'Masukkan URL tugas (Google Drive, YouTube, dll)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _buildSubmitSection(context),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Riwayat Pengumpulan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitSection(BuildContext context) {
    return BlocConsumer<PengumpulanTugasBloc, PengumpulanTugasState>(
      listener: (context, state) {
        if (state is PengumpulanTugasSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tugas berhasil dikumpulkan!'),
              backgroundColor: Colors.green,
            ),
          );
          _linkController.clear();
        } else if (state is PengumpulanTugasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              state is PengumpulanTugasSubmitting
                  ? null
                  : () {
                    if (_linkController.text.isNotEmpty) {
                      final submissionDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(DateTime.now());
                      context.read<PengumpulanTugasBloc>().add(
                        SubmitTugas(
                          siswaId: widget.siswaId,
                          tugasId: widget.tugasId,
                          linkTugas: _linkController.text,
                          tanggalPengumpulan: submissionDate,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link tugas tidak boleh kosong'),
                        ),
                      );
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF328E6E),
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(double.infinity, 0),
          ),
          child:
              state is PengumpulanTugasSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Kirim Tugas', style: TextStyle(fontSize: 16)),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    return Expanded(
      child: BlocBuilder<PengumpulanTugasBloc, PengumpulanTugasState>(
        builder: (context, state) {
          if (state is PengumpulanTugasLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PengumpulanTugasLoaded) {
            // Tidak perlu menambahkan submission manual karena sudah di-handle oleh bloc
            if (state.listTugas.isEmpty) {
              return const Center(child: Text('Belum ada riwayat pengumpulan'));
            }

            return ListView.builder(
              itemCount: state.listTugas.length,
              itemBuilder: (context, index) {
                final tugas = state.listTugas[index];
                return _buildPengumpulanCard(tugas);
              },
            );
          } else if (state is PengumpulanTugasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<PengumpulanTugasBloc>().add(
                          LoadPengumpulanTugas(
                            siswaId: widget.siswaId,
                            tugasId: widget.tugasId,
                          ),
                        ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPengumpulanCard(PengumpulanTugas tugas) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dikumpulkan: ${DateFormat('dd MMM yyyy').format(DateTime.parse(tugas.tanggalPengumpulan))}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(tugas.status),
                  backgroundColor:
                      tugas.status == 'Dikumpulkan'
                          ? Colors.green[100]
                          : Colors.orange[100],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Link Tugas: ${tugas.linkTugas}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            if (tugas.nilai > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Nilai: ${tugas.nilai}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
            if (tugas.komentar.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Komentar: ${tugas.komentar}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
