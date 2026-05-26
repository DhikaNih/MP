// lib/task_model.dart
// Model data untuk satu tugas

class Task {
  final int id;
  final String icon;
  final String iconBg; // hex string, e.g. '#FEE2E2'
  final String title;
  final String subtitle;
  final String priority; // 'Penting' | 'Sedang' | 'Rendah'
  bool isDone;
  final DateTime? dueDate; // added

  Task({
    required this.id,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.priority,
    this.isDone = false,
    this.dueDate,
  });

  // Salin task dengan perubahan tertentu
  Task copyWith({
    int? id,
    String? icon,
    String? iconBg,
    String? title,
    String? subtitle,
    String? priority,
    bool? isDone,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      iconBg: iconBg ?? this.iconBg,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}