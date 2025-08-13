import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/build_header_logo.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/sutdent_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'other_menu_grid.dart';
import 'today_subject_list.dart';

class DashboardLoadedView extends StatelessWidget {
  final DashboardResponse dashboard;
  const DashboardLoadedView({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder:
                  (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      curve: Curves.easeOutCubic,
                      child: widget,
                    ),
                  ),
              children: [
                const BuildHeaderLogo(),
                const SizedBox(height: 20),
                BuildStudentInfoCard(
                  student: dashboard.siswa,
                  rombel: dashboard.rombel,
                  periode: dashboard.periode,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mata Pelajaran Hari Ini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A5C),
                  ),
                ),
                const SizedBox(height: 10),
                TodaySubjectList(rombelId: dashboard.rombel.id),
                const SizedBox(height: 20),
                const Text(
                  'Menu Lainnya',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A5C),
                  ),
                ),
                const SizedBox(height: 10),
                OtherMenuGrid(rombelId: dashboard.rombel.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
