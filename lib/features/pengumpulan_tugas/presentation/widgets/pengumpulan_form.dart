import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/bloc/pengumpulan_tugas_bloc.dart';
import 'package:e_learning_mobile/utils/url_launcher.dart';
import 'package:intl/intl.dart';

class PengumpulanForm extends StatefulWidget {
  final int siswaRombelId;
  final int tugasId;
  final bool hasPengumpulan;

  const PengumpulanForm({
    super.key,
    required this.siswaRombelId,
    required this.tugasId,
    required this.hasPengumpulan,
  });

  @override
  State<PengumpulanForm> createState() => _PengumpulanFormState();
}

class _PengumpulanFormState extends State<PengumpulanForm> {
  final _linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHovered = false;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      if (widget.hasPengumpulan) {
        final currentState = context.read<PengumpulanTugasBloc>().state;
        if (currentState is PengumpulanTugasLoaded) {
          context.read<PengumpulanTugasBloc>().add(
            UpdatePengumpulan(
              idPengumpulan: currentState.pengumpulan!.idPengumpulanTugas,
              linkTugas: _linkController.text,
              tanggalPengumpulan: formattedDate,
            ),
          );
        }
      } else {
        context.read<PengumpulanTugasBloc>().add(
          SubmitTugas(
            tugasId: widget.tugasId,
            linkTugas: _linkController.text,
            tanggalPengumpulan: formattedDate,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PengumpulanTugasBloc, PengumpulanTugasState>(
      listener: (context, state) {
        if (state is PengumpulanTugasSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          _linkController.clear();

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
        } else if (state is PengumpulanTugasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state is PengumpulanTugasSubmitting ||
            state is PengumpulanTugasUpdating;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.teal.shade100.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _linkController,
                  decoration: InputDecoration(
                    labelText: 'Link Tugas',
                    hintText: 'https://drive.google.com/...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.link, color: Colors.teal),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.open_in_new, color: Colors.teal),
                      onPressed: () {
                        if (_linkController.text.isNotEmpty) {
                          launchURL(context, _linkController.text);
                        }
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Link tugas tidak boleh kosong';
                    }
                    if (!Uri.parse(value).isAbsolute) {
                      return 'Masukkan URL yang valid';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          _isHovered
                              ? [Colors.teal.shade600, Colors.teal.shade400]
                              : [Colors.teal.shade500, Colors.teal.shade300],
                    ),
                    boxShadow:
                        _isHovered
                            ? [
                              BoxShadow(
                                color: Colors.teal.shade400,
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                            ]
                            : [
                              BoxShadow(
                                color: Colors.teal.shade300,
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: const Offset(0, 3),
                              ),
                            ],
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.hasPengumpulan
                                      ? Icons.update
                                      : Icons.send,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.hasPengumpulan
                                      ? 'Perbarui Pengumpulan'
                                      : 'Kirim Tugas',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
