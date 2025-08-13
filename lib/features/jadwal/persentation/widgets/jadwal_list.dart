import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import 'package:e_learning_mobile/features/jadwal/persentation/widgets/jadwal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class JadwalList extends StatelessWidget {
  final List<Jadwal> jadwal;
  final int selectedDayIndex;
  final DashboardResponse siswaRombel;
  final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  JadwalList({
    super.key,
    required this.jadwal,
    required this.selectedDayIndex,
    required this.siswaRombel,
  });

  List<Jadwal> _filterAndDeduplicateSchedules() {
    final filteredByDay =
        jadwal
            .where(
              (j) =>
                  j.hari.name.toLowerCase() ==
                  days[selectedDayIndex].toLowerCase(),
            )
            .toList();

    final uniqueSchedules = <Jadwal>[];
    final seenTimes = <String>{};

    for (final j in filteredByDay) {
      final timeKey = '${j.jamMulai}-${j.jamSelesai}';
      if (!seenTimes.contains(timeKey)) {
        seenTimes.add(timeKey);
        uniqueSchedules.add(j);
      }
    }

    return uniqueSchedules;
  }

  @override
  Widget build(BuildContext context) {
    final schedules = _filterAndDeduplicateSchedules();

    if (schedules.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Tidak ada jadwal hari ini',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Silakan pilih hari lain untuk melihat jadwal',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                curve: Curves.easeOutQuad,
                child: JadwalCard(
                  jadwal: schedules[index],
                  siswaRombel: siswaRombel,
                  onTap: () {
                    // Handle card tap if needed
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
