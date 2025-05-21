import 'package:flutter/material.dart';

class BuildHeaderIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  const BuildHeaderIcon({super.key, required this.icon, required this.label});

  @override
  State<BuildHeaderIcon> createState() => _BuildHeaderIconState();
}

class _BuildHeaderIconState extends State<BuildHeaderIcon> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(widget.icon, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }
}
