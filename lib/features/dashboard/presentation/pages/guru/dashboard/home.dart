import 'package:flutter/material.dart';

class GuruDashboardPage extends StatelessWidget {
  const GuruDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Text(
          'Welcome to the Dashboard Guru!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
