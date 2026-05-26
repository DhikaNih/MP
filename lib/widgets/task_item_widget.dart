// lib/widgets/task_item_widget.dart
// Widget tugas yang bisa dipakai ulang di HomePage dan TasksPage

import 'package:flutter/material.dart';
import '../task_model.dart';
import '../priority_helper.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final bool isLast;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit; // new

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
    this.isLast = false,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final pColor = PriorityHelper.labelColor(task.priority);
    final pBg = PriorityHelper.labelBg(task.priority);
    final iconBg = hexToColor(task.iconBg);

    return Column(
      children: [
        // Swipe to delete
        Dismissible(
          key: Key('task_${task.id}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDelete?.call(),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: const Color(0xFFDC2626),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          child: InkWell(
            onTap: onToggle,
            onLongPress: onEdit, // long press to edit
            borderRadius: BorderRadius.circular(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      task.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: task.isDone
                                ? const Color(0xFFAAAAAA)
                                : const Color(0xFF111111),
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          task.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                          ),
                        ),
                        if (task.dueDate != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.event, size: 12, color: Color(0xFF888888)),
                              const SizedBox(width: 4),
                              Text(
                                '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Priority badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: pBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: pColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Checkbox
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isDone
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isDone
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                      ),
                      child: task.isDone
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            color: Colors.grey.shade100,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}