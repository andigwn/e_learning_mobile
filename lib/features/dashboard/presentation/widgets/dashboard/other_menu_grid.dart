import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OtherMenuGrid extends StatelessWidget {
  final int rombelId;
  const OtherMenuGrid({super.key, required this.rombelId});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.8, // Diperkecil dari 2.5
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          final List<Map<String, dynamic>> menuItems = [
            {
              'title': 'Jadwal Pelajaran',
              'icon': Icons.calendar_today,
              'route': Routes.jadwal,
            },
            {
              'title': 'Kehadiran',
              'icon': Icons.person,
              'route': Routes.kehadiran,
            },
            {
              'title': 'Hasil Studi',
              'icon': Icons.assignment,
              'route': Routes.hasilStudi,
            },
            {'title': 'Nilai', 'icon': Icons.grade, 'route': Routes.nilai},
          ];

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: 2,
            child: ScaleAnimation(
              curve: Curves.easeOutBack,
              child: FadeInAnimation(
                child: MenuCard(
                  title: menuItems[index]['title'],
                  icon: menuItems[index]['icon'],
                  onTap: () {
                    context.goNamed(menuItems[index]['route'], extra: rombelId);
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
