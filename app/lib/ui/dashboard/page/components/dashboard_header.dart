import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onLogout;

  const DashboardHeader({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Color(0xFF18181B),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Visao geral da academia',
                style: TextStyle(
                  color: Color(0xFF71717A),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE4E4E7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/150?u=admin'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Logout provisório',
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: Color(0xFF3F3F46)),
        ),
      ],
    );
  }
}
