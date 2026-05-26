// lib/app_state.dart
// State management sederhana menggunakan InheritedWidget
// Tidak butuh package tambahan (tanpa Provider/Riverpod)

import 'package:flutter/material.dart';
import 'task_model.dart';

// ─── AppState: menyimpan & mengelola data tugas ───────────────────────────────
class AppState extends ChangeNotifier {
  // Daftar tugas awal (dummy data) dengan due dates
  final List<Task> _tasks = [
    Task(
      id: 1,
      icon: '📄',
      iconBg: '#FEE2E2',
      title: 'Essay Bahasa Indonesia',
      subtitle: 'Besok, 23:59 • 1500 kata',
      priority: 'Penting',
      dueDate: DateTime(2026, 5, 21),
    ),
    Task(
      id: 2,
      icon: '🧮',
      iconBg: '#DBEAFE',
      title: 'Kalkulus Latihan 4',
      subtitle: '29 Apr, 12:00 • Bab 7-8',
      priority: 'Penting',
      dueDate: DateTime(2026, 5, 12),
    ),
    Task(
      id: 3,
      icon: '🔬',
      iconBg: '#D1FAE5',
      title: 'Laporan Praktikum Fisika',
      subtitle: '30 Apr, 08:00 • 5 halaman',
      priority: 'Sedang',
      dueDate: DateTime(2026, 5, 25),
    ),
    Task(
      id: 4,
      icon: '📖',
      iconBg: '#FEF3C7',
      title: 'Baca Bab 12 Sejarah',
      subtitle: '2 Mei, 14:00 • Ringkasan',
      priority: 'Rendah',
      dueDate: DateTime(2026, 5, 30),
    ),
    Task(
      id: 5,
      icon: '💻',
      iconBg: '#DBEAFE',
      title: 'Tugas Pemrograman Web',
      subtitle: '5 Mei, 23:59 • React App',
      priority: 'Sedang',
      dueDate: DateTime(2026, 5, 20),
    ),
  ];

  int _nextId = 6;

  // Getter: semua tugas
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Getter: tugas belum selesai
  List<Task> get pendingTasks => _tasks.where((t) => !t.isDone).toList();

  // Getter: tugas selesai
  List<Task> get doneTasks => _tasks.where((t) => t.isDone).toList();

  // Getter: tugas prioritas penting yang belum selesai
  List<Task> get importantTasks =>
      _tasks.where((t) => t.priority == 'Penting' && !t.isDone).toList();

  // Toggle status selesai/belum
  void toggleDone(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
    }
  }

  // Tambah tugas baru
  void addTask({
    required String icon,
    required String iconBg,
    required String title,
    required String subtitle,
    required String priority,
    DateTime? dueDate,
  }) {
    _tasks.insert(
      0,
      Task(
        id: _nextId++,
        icon: icon,
        iconBg: iconBg,
        title: title,
        subtitle: subtitle,
        priority: priority,
        dueDate: dueDate,
      ),
    );
    notifyListeners();
  }

  // Update tugas yang sudah ada
  void updateTask({
    required int id,
    required String icon,
    required String iconBg,
    required String title,
    required String subtitle,
    required String priority,
    DateTime? dueDate,
  }) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = Task(
        id: id,
        icon: icon,
        iconBg: iconBg,
        title: title,
        subtitle: subtitle,
        priority: priority,
        isDone: _tasks[index].isDone,
        dueDate: dueDate,
      );
      notifyListeners();
    }
  }

  // Hapus tugas berdasarkan id
  void deleteTask(int id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

// ─── InheritedNotifier: mendistribusikan AppState ke seluruh widget tree ──────
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  // Akses AppState dari context mana saja
  static AppState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope tidak ditemukan di widget tree');
    return scope!.notifier!;
  }
}