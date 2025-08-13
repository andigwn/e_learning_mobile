import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/absensi/data/model/lokasi_model.dart';
import 'package:e_learning_mobile/features/absensi/domain/repository/absensi_repository.dart';
import 'package:e_learning_mobile/features/absensi/bloc/absensi_bloc.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import 'package:e_learning_mobile/features/dashboard/domain/repositories/student_repo.dart';
import 'package:e_learning_mobile/features/jadwal/domain/repositories/jadwal_repo.dart';
import 'views/absensi_loading_view.dart';
import 'views/absensi_error_view.dart';
import 'views/absensi_main_view.dart';

class AbsensiPage extends StatefulWidget {
  final int siswaRombelId;
  final int jadwalId;
  const AbsensiPage({
    super.key,
    required this.siswaRombelId,
    required this.jadwalId,
  });

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  late final AbsensiBloc _absensiBloc;
  DashboardResponse? _siswaRombel;
  Jadwal? _jadwal;
  bool _isJadwalSelesai = false;
  bool _isHariJadwal = false;
  bool _isBelumMulai = false;
  Timer? _jadwalTimer;
  bool _isLoading = true;
  String? _errorMessage;
  LokasiModel? _lokasiSekolah;
  bool _isLoadingLocation = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _absensiBloc = context.read<AbsensiBloc>();
    _loadData();
    _loadSchoolLocation();
  }

  Future<void> _loadSchoolLocation() async {
    if (_isLoadingLocation) return;

    setState(() => _isLoadingLocation = true);

    try {
      final absensiRepo = context.read<AbsensiRepository>();
      final locationData = await absensiRepo.getSchoolLocation();

      setState(() {
        _lokasiSekolah = LokasiModel(
          id: locationData['id'] as int? ?? 0,
          namaLokasi: locationData['nama_lokasi'] as String? ?? 'Sekolah',
          latitudePusat: (locationData['latitude_pusat'] as num).toDouble(),
          longitudePusat: (locationData['longitude_pusat'] as num).toDouble(),
          radiusMeter: (locationData['radius_meter'] as num).toInt(),
        );
      });
    } on AbsensiException catch (e) {
      setState(() => _locationError = e.message);
    } catch (e) {
      setState(
        () => _locationError = 'Gagal memuat data lokasi: ${e.toString()}',
      );
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _loadData() async {
    try {
      final studentRepo = context.read<StudentRepository>();
      final studentResponse = await studentRepo.getStudentDashboard();
      setState(() => _siswaRombel = studentResponse);

      final jadwalRepo = context.read<JadwalRepo>();
      final jadwalList = await jadwalRepo.getJadwal(_siswaRombel!.rombel.id);
      setState(
        () =>
            _jadwal = jadwalList.firstWhere(
              (item) => item.id == widget.jadwalId,
            ),
      );

      _updateJadwalStatus();
      _checkHariJadwal();

      _absensiBloc.add(
        LoadAbsensiEvent(
          siswaRombelId: widget.siswaRombelId,
          jadwalId: widget.jadwalId,
        ),
      );

      _jadwalTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (mounted) {
          setState(() {
            _updateJadwalStatus();
            _checkHariJadwal();
          });
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _jadwalTimer?.cancel();
    super.dispose();
  }

  void _checkHariJadwal() {
    if (_jadwal == null) return;

    final now = DateTime.now();
    final today = DateFormat('EEEE', 'id_ID').format(now).toLowerCase();
    final hariJadwal = _jadwal!.hari.name.toLowerCase();

    setState(() => _isHariJadwal = today == hariJadwal);
  }

  void _updateJadwalStatus() {
    if (_jadwal == null) return;

    setState(() {
      _isJadwalSelesai = _calculateJadwalSelesai();
      _isBelumMulai = _calculateBelumMulai();
    });
  }

  bool _calculateJadwalSelesai() {
    try {
      final now = DateTime.now();
      final jamSelesaiStr = _jadwal!.jamSelesai.format(context);
      final jamSelesaiDt = DateFormat('HH:mm').parse(jamSelesaiStr);

      final jamSelesaiToday = DateTime(
        now.year,
        now.month,
        now.day,
        jamSelesaiDt.hour,
        jamSelesaiDt.minute,
      );

      return now.isAfter(jamSelesaiToday);
    } catch (e) {
      debugPrint('Error checking jadwal: $e');
      return true;
    }
  }

  bool _calculateBelumMulai() {
    try {
      final now = DateTime.now();
      final jamMulaiStr = _jadwal!.jamMulai.format(context);
      final jamMulaiDt = DateFormat('HH:mm').parse(jamMulaiStr);

      final jamMulaiToday = DateTime(
        now.year,
        now.month,
        now.day,
        jamMulaiDt.hour,
        jamMulaiDt.minute,
      );

      return now.isBefore(jamMulaiToday);
    } catch (e) {
      debugPrint('Error checking jam mulai: $e');
      return false;
    }
  }

  Future<void> _absenMasuk() async {
    if (!mounted || _jadwal == null || _siswaRombel == null) return;

    if (_isBelumMulai) return _showMessage('Belum waktu absen');
    if (_isJadwalSelesai) return _showMessage('Waktu absen sudah berakhir');
    if (!_isHariJadwal) {
      return _showMessage('Hari ini bukan jadwal ${_jadwal!.hari.name}');
    }

    final position = await _getCurrentLocation();
    if (position == null) return;

    final inRange = await _checkDistance(position);
    if (!inRange!) return _showMessage('Anda berada di luar area sekolah');

    _absensiBloc.add(
      AbsenMasukEvent(
        siswaRombelId: widget.siswaRombelId,
        jadwalId: widget.jadwalId,
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  Future<bool?> _checkDistance(Position position) async {
    if (_isLoadingLocation) {
      return _showMessageAndReturn('Sedang memverifikasi lokasi...', false);
    }
    if (_locationError != null) {
      return _showMessageAndReturn(_locationError!, false);
    }
    if (_lokasiSekolah == null) {
      return _showMessageAndReturn('Data lokasi sekolah belum tersedia', false);
    }

    try {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _lokasiSekolah!.latitudePusat,
        _lokasiSekolah!.longitudePusat,
      );

      final isInRange = distance <= _lokasiSekolah!.radiusMeter;
      if (!isInRange) {
        _showMessage('Anda ${distance.toStringAsFixed(0)}m dari sekolah');
      }

      return isInRange;
    } catch (e) {
      debugPrint('Distance calculation error: $e');
      return _showMessageAndReturn('Gagal memverifikasi lokasi', false);
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _showMessageAndReturn(
          'Aktifkan layanan lokasi untuk absen',
          null,
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _showMessageAndReturn('Izin lokasi ditolak', null);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _showMessageAndReturn(
          'Buka pengaturan untuk mengizinkan lokasi',
          null,
        );
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (e) {
      debugPrint('Location error: $e');
      return _showMessageAndReturn('Gagal mendapatkan lokasi', null);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[700],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  T? _showMessageAndReturn<T>(String message, T? returnValue) {
    _showMessage(message);
    return returnValue;
  }

  Future<void> _handleRefresh() async {
    _absensiBloc.add(
      LoadAbsensiEvent(
        siswaRombelId: widget.siswaRombelId,
        jadwalId: widget.jadwalId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const AbsensiLoadingView();
    if (_errorMessage != null) {
      return AbsensiErrorView(
        errorMessage: _errorMessage!,
        onBackPressed: () => Navigator.pop(context),
      );
    }
    if (_siswaRombel == null || _jadwal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Data siswa atau jadwal tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Absensi Siswa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF328E6E),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
      ),
      body: AbsensiMainView(
        siswaRombelId: widget.siswaRombelId,
        jadwalId: widget.jadwalId,
        siswaRombel: _siswaRombel!,
        jadwal: _jadwal!,
        isJadwalSelesai: _isJadwalSelesai,
        isHariJadwal: _isHariJadwal,
        isBelumMulai: _isBelumMulai,
        onAbsenMasuk: _absenMasuk,
        onRefresh: _handleRefresh,
      ),
    );
  }
}
