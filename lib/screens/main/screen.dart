import 'package:flutter/material.dart';
import 'package:hackathon_rower/screens/main/pages/home.dart';
import 'package:hackathon_rower/screens/main/pages/map.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.map), label: "Mapa")
        ],
      ),
      body: SafeArea(child: const [HomePage(), MapPage()][currentPageIndex]),
    );
  }
}
