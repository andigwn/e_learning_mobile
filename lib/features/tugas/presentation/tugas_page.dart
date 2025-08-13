import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:e_learning_mobile/features/tugas/bloc/tugas_bloc.dart';
import 'widgets/tugas_card.dart';
import 'widgets/tugas_empty_state.dart';
import 'widgets/tugas_error_state.dart';

class TugasPage extends StatelessWidget {
  final int jadwalId;
  const TugasPage({super.key, required this.jadwalId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade700, Colors.teal.shade500],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<TugasBloc>().add(LoadTugas(jadwalId)),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              // ignore: deprecated_member_use
              theme.primaryColor.withOpacity(0.03),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: MultiBlocListener(
          listeners: [
            BlocListener<StudentBloc, StudentState>(
              listener: (context, state) {
                if (state is StudentError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),
          ],
          child: BlocBuilder<StudentBloc, StudentState>(
            builder: (context, studentState) {
              int? siswaRombelId;
              if (studentState is StudentDashboardLoaded) {
                siswaRombelId = studentState.dashboard.id;
              }

              return BlocConsumer<TugasBloc, TugasState>(
                listener: (context, state) {
                  if (state is TugasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is TugasInitial || state is TugasLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Memuat tugas...',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is TugasEmpty) {
                    return const TugasEmptyState();
                  } else if (state is TugasLoaded) {
                    return AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: state.tugas.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: TugasCard(
                                    tugas: state.tugas[index],
                                    siswaRombelId: siswaRombelId,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is TugasError) {
                    return TugasErrorState(
                      message: state.message,
                      jadwalId: jadwalId,
                    );
                  }
                  return const SizedBox();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
