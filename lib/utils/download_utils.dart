import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_learning_mobile/core/constant/api_constant.dart';
import 'package:lottie/lottie.dart';

Future<void> downloadFile(BuildContext context, String fileUrl) async {
  final fullUrl = '${ApiConstants.fileUrl}$fileUrl';

  try {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin penyimpanan diperlukan untuk mengunduh file'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dir = await getDownloadsDirectory();
    if (dir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat menemukan direktori unduhan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final fileName = fileUrl.split('/').last;
    final savePath = "${dir.path}/$fileName";

    // Show download dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/download.json',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Mengunduh File',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                fileName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ),
        );
      },
    );

    await Dio().download(fullUrl, savePath);
    Navigator.of(context).pop(); // Close dialog

    final openResult = await OpenFile.open(savePath);
    if (openResult.type == ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File dibuka: $fileName'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka file: ${openResult.message}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    Navigator.of(context).pop(); // Close dialog on error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkVersion = androidInfo.version.sdkInt;

    if (sdkVersion >= 30) {
      if (await Permission.manageExternalStorage.isGranted) return true;
      final status = await Permission.manageExternalStorage.request();
      if (status.isPermanentlyDenied) await openAppSettings();
      return status.isGranted;
    } else {
      if (await Permission.storage.isGranted) return true;
      final result = await Permission.storage.request();
      return result.isGranted;
    }
  } else if (Platform.isIOS) {
    if (await Permission.storage.isGranted) return true;
    final result = await Permission.storage.request();
    return result.isGranted;
  }
  return true;
}
