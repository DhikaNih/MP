// lib/main.dart

import 'package:flutter/material.dart';
import 'app_state.dart';
import 'home_page.dart';
import 'tasks_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';
import 'widgets/add_task_sheet.dart';

void main() => runApp(const StudentReminderApp());

class StudentReminderApp extends StatelessWidget {
  const StudentReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bungkus seluruh app dengan AppStateScope agar state bisa diakses di mana saja
    return AppStateScope(
      state: AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pengingat Tugas',
        theme: ThemeData(
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Halaman-halaman utama
  static const List<Widget> _pages = [
    HomePage(),
    TasksPage(),
    CalendarPage(),
    SettingsPage(),
  ];

  // Buka bottom sheet tambah tugas
  void _openAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Penting agar sheet naik saat keyboard muncul
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // IndexedStack menjaga state setiap halaman saat pindah tab
        index: _currentIndex,
        children: _pages,
      ),

      // Tombol tambah tugas
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        backgroundColor: const Color(0xFF2563EB),
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: Colors.white,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_filled,
              label: 'Beranda',
              isActive: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            _NavItem(
              icon: Icons.assignment_outlined,
              label: 'Tugas',
              isActive: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(width: 48), // Ruang untuk FAB
            _NavItem(
              icon: Icons.calendar_month_outlined,
              label: 'Kalender',
              isActive: _currentIndex == 2,
              onTap: () => setState(() => _currentIndex = 2),
            ),
            _NavItem(
              icon: Icons.settings_outlined,
              label: 'Pengaturan',
              isActive: _currentIndex == 3,
              onTap: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget item navigasi bawah ───────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
