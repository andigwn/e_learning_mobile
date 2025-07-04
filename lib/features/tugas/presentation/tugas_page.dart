import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:e_learning_mobile/features/tugas/bloc/tugas_bloc.dart';
import 'package:e_learning_mobile/features/tugas/data/model/tugas_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TugasPage extends StatelessWidget {
  final int jadwalId;
  const TugasPage({super.key, required this.jadwalId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: BlocBuilder<TugasBloc, TugasState>(
        builder: (context, state) {
          if (state is TugasInitial) {
            context.read<TugasBloc>().add(LoadTugas(jadwalId));
            return const Center(child: CircularProgressIndicator());
          } else if (state is TugasLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TugasLoaded) {
            if (state.tugas.isEmpty) {
              return const Center(child: Text('Tidak ada tugas.'));
            }
            return ListView.builder(
              itemCount: state.tugas.length,
              itemBuilder: (context, index) {
                final Tugas tugas = state.tugas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(tugas.judul ?? '-'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tugas.deskripsi ?? '-'),
                        if (tugas.deadline != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Deadline: ${tugas.deadline}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            if (tugas.filePetunjuk != null &&
                                tugas.filePetunjuk!.isNotEmpty)
                              TextButton.icon(
                                onPressed:
                                    () => _downloadAndOpenFile(
                                      context,
                                      tugas.filePetunjuk!,
                                    ),
                                icon: const Icon(Icons.download),
                                label: const Text('Unduh File'),
                              ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implementasi aksi kerjakan tugas
                              },
                              child: const Text('Kerjakan'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    leading: const Icon(Icons.assignment),
                  ),
                );
              },
            );
          } else if (state is TugasError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Future<void> _downloadAndOpenFile(
    BuildContext context,
    String fileUrl,
  ) async {
    final fullUrl = '${ApiConstants.fileUrl}$fileUrl';
    print('Download URL: $fullUrl');

    // Meminta izin penyimpanan
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin penyimpanan diperlukan untuk mengunduh file'),
        ),
      );
      return;
    }

    try {
      // Mendapatkan direktori unduhan
      final dir = await getDownloadsDirectory();
      if (dir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat menemukan direktori unduhan'),
          ),
        );
        return;
      }

      final fileName = fileUrl.split('/').last;
      final savePath = "${dir.path}/$fileName";

      // Mengunduh file
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mengunduh file $fileName...'),
          duration: const Duration(seconds: 2),
        ),
      );

      await Dio().download(fullUrl, savePath);

      // Membuka file
      final openResult = await OpenFile.open(savePath);

      if (openResult.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka file: ${openResult.message}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File berhasil diunduh: $fileName')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Fungsi untuk meminta izin penyimpanan
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;

      if (sdkVersion >= 30) {
        // Android 11 (API 30) atau lebih tinggi
        if (await Permission.manageExternalStorage.isGranted) {
          return true;
        }

        // Meminta izin MANAGE_EXTERNAL_STORAGE
        final status = await Permission.manageExternalStorage.request();

        if (status.isPermanentlyDenied) {
          // Jika izin ditolak permanen, arahkan ke pengaturan
          await openAppSettings();
        }

        return status.isGranted;
      } else {
        // Di bawah Android 11
        final status = await Permission.storage.status;
        if (status.isGranted) {
          return true;
        } else {
          final result = await Permission.storage.request();
          return result.isGranted;
        }
      }
    } else if (Platform.isIOS) {
      // Untuk iOS
      final status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      } else {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
    }
    // Platform lain, kita asumsikan izin diberikan
    return true;
  }
}
