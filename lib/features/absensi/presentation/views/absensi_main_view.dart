import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/absensi/bloc/absensi_bloc.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import '../widgets/student_info_card.dart';
import '../widgets/absen_button.dart';
import '../widgets/absensi_table.dart';

class AbsensiMainView extends StatelessWidget {
  final int siswaRombelId;
  final int jadwalId;
  final DashboardResponse siswaRombel;
  final Jadwal jadwal;
  final bool isJadwalSelesai;
  final bool isHariJadwal;
  final bool isBelumMulai;
  final VoidCallback onAbsenMasuk;
  final RefreshCallback onRefresh;

  const AbsensiMainView({
    super.key,
    required this.siswaRombelId,
    required this.jadwalId,
    required this.siswaRombel,
    required this.jadwal,
    required this.isJadwalSelesai,
    required this.isHariJadwal,
    required this.isBelumMulai,
    required this.onAbsenMasuk,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsensiBloc, AbsensiState>(
      builder: (context, state) {
        final isSubmitting = state is AbsensiSubmitting;

        return RefreshIndicator(
          color: Colors.blue[700],
          backgroundColor: Colors.white,
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: StudentInfoCard(
                    key: ValueKey(jadwal.id),
                    siswaRombel: siswaRombel,
                    jadwal: jadwal,
                    isBelumMulai: isBelumMulai,
                    isJadwalSelesai: isJadwalSelesai,
                    isHariJadwal: isHariJadwal,
                  ),
                ),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: AbsenButton(
                    key: ValueKey(state),
                    isDisabled:
                        isJadwalSelesai ||
                        isSubmitting ||
                        !isHariJadwal ||
                        isBelumMulai,
                    isSubmitting: isSubmitting,
                    isBelumMulai: isBelumMulai,
                    isJadwalSelesai: isJadwalSelesai,
                    isHariJadwal: isHariJadwal,
                    jadwal: jadwal,
                    onPressed: onAbsenMasuk,
                    errorMessage: state is AbsensiError ? state.message : null,
                  ),
                ),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildAbsensiContent(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAbsensiContent(AbsensiState state) {
    if (state is AbsensiLoaded || state is AbsensiError) {
      return AbsensiTable(
        key: ValueKey(state),
        absensiList:
            state is AbsensiLoaded
                ? state.absensiList
                : (state as AbsensiError).lastAbsensi,
      );
    } else if (state is AbsensiLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Memuat data absensi...',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
