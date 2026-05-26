enum Quadrant { urgentImportant, importantNotUrgent, urgentNotImportant, notUrgentNotImportant }

class Task {
  String id;
  String title;
  String description;
  DateTime deadline;
  Quadrant quadrant;
  bool isCompleted;

  Task ({
    required this.id,
    required this.title,
    this.description = '',
    required this.deadline,
    required this.quadrant,
    this.isCompleted = false,
  });
}