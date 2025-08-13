import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/bloc/pengumpulan_tugas_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/presentation/widgets/pengumpulan_form.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/presentation/widgets/riwayat_list.dart';
import 'package:flutter/scheduler.dart';

class PengumpulanTugasPage extends StatefulWidget {
  final int siswaRombelId;
  final int tugasId;

  const PengumpulanTugasPage({
    super.key,
    required this.siswaRombelId,
    required this.tugasId,
  });

  @override
  State<PengumpulanTugasPage> createState() => _PengumpulanTugasPageState();
}

class _PengumpulanTugasPageState extends State<PengumpulanTugasPage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Inisialisasi controller animasi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Setup animasi fade
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Setup animasi slide
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Jalankan animasi
    _animationController.forward();

    // Inisialisasi data setelah frame pertama selesai
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // context.read<PengumpulanTugasBloc>().add(
      //   LoadPengumpulanSiswa(
      //     tugasId: widget.tugasId,
      //     siswaRombelId: widget.siswaRombelId,
      //   ),
      // );
      context.read<PengumpulanTugasBloc>().add(
        LoadRiwayatPengumpulanTugasSiswa(
          siswaRombelId: widget.siswaRombelId,
          tugasId: widget.tugasId,
          page: 1,
          size: 10,
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<PengumpulanTugasBloc>().add(
        LoadRiwayatPengumpulanTugasSiswa(
          siswaRombelId: widget.siswaRombelId,
          tugasId: widget.tugasId,
          page: 1,
          size: 10,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // expandedHeight: 150,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Pengumpulan Tugas',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.teal.shade700,
                      Colors.teal.shade500,
                      Colors.teal.shade400,
                    ],
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  // context.read<PengumpulanTugasBloc>().add(
                  //   LoadPengumpulanSiswa(
                  //     tugasId: widget.tugasId,
                  //     siswaRombelId: widget.siswaRombelId,
                  //   ),
                  // );
                  context.read<PengumpulanTugasBloc>().add(
                    LoadRiwayatPengumpulanTugasSiswa(
                      siswaRombelId: widget.siswaRombelId,
                      tugasId: widget.tugasId,
                      page: 1,
                      size: 10,
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<PengumpulanTugasBloc, PengumpulanTugasState>(
                builder: (context, state) {
                  final hasPengumpulan =
                      state is PengumpulanTugasLoaded &&
                      state.pengumpulan != null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.teal.shade50,
                                  Colors.teal.shade100,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.shade100,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      hasPengumpulan
                                          ? Icons.check_circle
                                          : Icons.assignment,
                                      color:
                                          hasPengumpulan
                                              ? Colors.green.shade700
                                              : Colors.teal.shade700,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        hasPengumpulan
                                            ? 'Tugas Telah Dikumpulkan'
                                            : 'Kirim Tugas Anda',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              hasPengumpulan
                                                  ? Colors.green.shade800
                                                  : Colors.teal.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  hasPengumpulan
                                      ? 'Anda dapat memperbarui pengumpulan sebelum deadline'
                                      : 'Silakan kumpulkan tugas sebelum deadline',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      PengumpulanForm(
                        siswaRombelId: widget.siswaRombelId,
                        tugasId: widget.tugasId,
                        hasPengumpulan: hasPengumpulan,
                      ),

                      const SizedBox(height: 30),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                        height: 20,
                        indent: 20,
                        endIndent: 20,
                      ),
                      const SizedBox(height: 15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: Colors.teal.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Riwayat Pengumpulan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverFillRemaining(
            child: RiwayatList(
              scrollController: _scrollController,
              siswaRombelId: widget.siswaRombelId,
              tugasId: widget.tugasId,
            ),
          ),
        ],
      ),
    );
  }
}
