import 'package:flutter/material.dart';
import 'package:mytuberculose_app/presentation/screens/treatments_screen.dart';
import 'package:mytuberculose_app/presentation/screens/appointments_screen.dart';
import 'package:mytuberculose_app/presentation/screens/info_screen.dart';
import 'package:mytuberculose_app/presentation/screens/profile_screen.dart';
// TODO: Import AppLocalizations when needed for titles

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // List of widgets to display in the body based on the selected index
  static const List<Widget> _widgetOptions = <Widget>[
    TreatmentsScreen(),
    AppointmentsScreen(),
    InfoScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Use AppLocalizations for item labels
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            activeIcon: Icon(Icons.medication),
            label: 'Traitements', // Localize later
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Rendez-vous', // Localize later
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'Infos', // Localize later
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil', // Localize later
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary, // Use theme color
        unselectedItemColor: Colors.grey, // Set color for unselected items
        showUnselectedLabels: true, // Ensure labels are always visible
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Use fixed type for 4+ items
      ),
    );
  }
}

