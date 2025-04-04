import 'package:easybox/login/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../form/farmData.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  LoginController loginController=Get.put(LoginController());
  // List of button data (icon, title, and color)
  final List<Map<String, dynamic>> buttons = [
    {
      'icon': Icons.list_alt,
      'title': 'View Lead',
      'color': Colors.blue,
    },
    {
      'icon': Icons.add_circle,
      'title': 'Add Lead',
      'color': Colors.green,
      'action': 'add', // Identifier for the add action
    },
    {
      'icon': Icons.edit,
      'title': 'Edit Data',
      'color': Colors.orange,
    },
    {
      'icon': Icons.delete,
      'title': 'Data Delete',
      'color': Colors.red,
    },
    {
      'icon': Icons.settings,
      'title': 'Settings',
      'color': Colors.purple,
    },
    {
      'icon': Icons.analytics,
      'title': 'Data',
      'color': Colors.teal,
    },
  ];

  void _handleButtonPress(BuildContext context, Map<String, dynamic> button) {
    print('${button['title']} pressed');

    if (button['action'] == 'add') {
      // Using GetX navigation
      Get.to(MyForm());

      // OR using standard Navigator (choose one)
      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyForm()));
    }
    // Add other button actions as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
             loginController.logout();
              // Ya jo bhi login route hai
            },
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            return _buildDashboardButton(
              icon: buttons[index]['icon'],
              title: buttons[index]['title'],
              color: buttons[index]['color'],
              onTap: () => _handleButtonPress(context, buttons[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this MyForm widget or import it from another file
