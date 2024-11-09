import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        StatCard(
          headingIcon: Icons.location_on_outlined,
          headingText: "Całkowity dystans",
          contentText: "317 km",
          gradientColors: [Color(0xFFec4899), Color(0xFFdb2777)],
        ),
        StatCard(
          headingIcon: Icons.local_fire_department_outlined,
          headingText: "Spalone kalorie",
          contentText: "12440 kcal",
          gradientColors: [Color(0xff06b6d4), Color(0xFF0ea5e9)],
        ),
        StatCard(
          headingIcon: Icons.speed,
          headingText: "Średnia prędkość",
          contentText: "19.8 km/h",
          gradientColors: [Color(0xff22c55e), Color(0xFF10b981)],
        )
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard(
      {super.key,
      required this.headingText,
      required this.contentText,
      required this.gradientColors,
      required this.headingIcon});
  final IconData headingIcon;
  final String headingText;
  final String contentText;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              )),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      headingIcon,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      headingText,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  contentText,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ],
            ),
          )),
    );
  }
}
