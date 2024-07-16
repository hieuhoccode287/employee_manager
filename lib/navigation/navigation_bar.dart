import 'package:flutter/material.dart';
import 'package:employee_manager/screens/employee_list_page.dart';
import 'package:employee_manager/screens/home_page.dart';
import 'package:employee_manager/screens/notifications_page.dart';
import 'package:employee_manager/screens/settings_page.dart';

class NavigationExample extends StatefulWidget {
  final String email;

  const NavigationExample({super.key, required this.email});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(email: widget.email), // Use widget.email here
      EmployeeListPage(),
      NotificationsPage(),
      SettingsPage(),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Danh sách',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
      body: _pages[currentPageIndex],
    );
  }
}
