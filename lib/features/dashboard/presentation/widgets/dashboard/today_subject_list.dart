import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/subject_card.dart';
import 'package:e_learning_mobile/features/jadwal/bloc/jadwal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TodaySubjectList extends StatelessWidget {
  final int rombelId;
  const TodaySubjectList({super.key, required this.rombelId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JadwalBloc, JadwalState>(
      builder: (context, jadwalState) {
        if (jadwalState is JadwalLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.teal.shade600,
            ),
          );
        } else if (jadwalState is JadwalLoaded) {
          final today = DateTime.now();
          final todayName =
              DateFormat('EEEE', 'id_ID').format(today).toLowerCase();

          final todayJadwal =
              jadwalState.jadwal.where((jadwal) {
                return jadwal.hari.name.toLowerCase() == todayName;
              }).toList();

          if (todayJadwal.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Tidak ada jadwal hari ini',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            );
          }

          return AnimationLimiter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(), // Diubah
                cacheExtent: 200, // Ditambahkan
                itemCount: todayJadwal.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        curve: Curves.easeOutQuad,
                        child: SubjectCard(
                          jadwal: todayJadwal[index],
                          onTap: () {},
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (jadwalState is JadwalError) {
          return Text(jadwalState.message);
        }
        return const SizedBox();
      },
    );
  }
}
