import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/bloc/pengumpulan_tugas_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/presentation/widgets/riwayat_card.dart';

class RiwayatList extends StatelessWidget {
  final ScrollController scrollController;
  final int siswaRombelId;
  final int tugasId;

  const RiwayatList({
    super.key,
    required this.scrollController,
    required this.siswaRombelId,
    required this.tugasId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PengumpulanTugasBloc, PengumpulanTugasState>(
      builder: (context, state) {
        if (state is PengumpulanTugasLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.teal.shade400,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'Memuat riwayat...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state is RiwayatPengumpulanTugasSiswaLoaded) {
          final riwayatList = state.riwayat;

          if (riwayatList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat pengumpulan',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: riwayatList.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < riwayatList.length) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: RiwayatCard(
                    key: ValueKey(riwayatList[index].idPengumpulanTugas),
                    tugas: riwayatList[index],
                    index: index,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal.shade400,
                    ),
                  ),
                );
              }
            },
          );
        } else if (state is PengumpulanTugasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade400, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat riwayat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed:
                      () => context.read<PengumpulanTugasBloc>().add(
                        LoadRiwayatPengumpulanTugasSiswa(
                          siswaRombelId: siswaRombelId,
                          tugasId: tugasId,
                          page: 1,
                          size: 10,
                        ),
                      ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
