// lib/calendar_page.dart

import 'package:flutter/material.dart';
import 'app_state.dart';
import 'task_model.dart';
import 'priority_helper.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedMonth = DateTime(2026, 5, 1);
  DateTime _selectedDate = DateTime(2026, 5, 20);

  static const _dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  static const _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
      _selectedDate = _focusedMonth;
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
      _selectedDate = _focusedMonth;
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Get tasks that have dueDate matching the given date
  List<Task> _getTasksForDate(List<Task> tasks, DateTime date) {
    return tasks.where((t) =>
        t.dueDate != null &&
        t.dueDate!.year == date.year &&
        t.dueDate!.month == date.month &&
        t.dueDate!.day == date.day).toList();
  }

  // Get set of days (1..31) that have tasks in the focused month
  Set<int> _getDaysWithTasks(List<Task> tasks, int year, int month) {
    return tasks
        .where((t) =>
            t.dueDate != null &&
            t.dueDate!.year == year &&
            t.dueDate!.month == month)
        .map((t) => t.dueDate!.day)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;
    final daysWithTasks = _getDaysWithTasks(
        state.tasks, _focusedMonth.year, _focusedMonth.month);
    final agendaTasks = _getTasksForDate(state.tasks, _selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bulan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      _NavButton(
                        icon: Icons.chevron_left,
                        onTap: _prevMonth,
                      ),
                      const SizedBox(width: 8),
                      _NavButton(
                        icon: Icons.chevron_right,
                        onTap: _nextMonth,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Grid Kalender
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Nama hari
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _dayNames
                        .map(
                          (d) => SizedBox(
                            width: 36,
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Grid tanggal
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisExtent: 44,
                    ),
                    itemCount: firstWeekday + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < firstWeekday) {
                        return const SizedBox.shrink();
                      }
                      final day = index - firstWeekday + 1;
                      final date = DateTime(
                          _focusedMonth.year, _focusedMonth.month, day);
                      final isToday = _isToday(date);
                      final isSelected = date.year == _selectedDate.year &&
                          date.month == _selectedDate.month &&
                          date.day == _selectedDate.day;
                      final hasTask = daysWithTasks.contains(day);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? const Color(0xFF2563EB)
                                    : isSelected
                                        ? const Color(0xFFDBEAFE)
                                        : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isToday
                                      ? Colors.white
                                      : isSelected
                                          ? const Color(0xFF2563EB)
                                          : Colors.black87,
                                ),
                              ),
                            ),
                            if (hasTask)
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2563EB),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Label Agenda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'Agenda ${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),

            // Daftar Agenda
            Expanded(
              child: agendaTasks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('📅', style: TextStyle(fontSize: 40)),
                          SizedBox(height: 8),
                          Text(
                            'Tidak ada tugas pada hari ini',
                            style: TextStyle(
                                color: Color(0xFF888888), fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: agendaTasks.length,
                      itemBuilder: (context, index) {
                        final task = agendaTasks[index];
                        final pColor =
                            PriorityHelper.labelColor(task.priority);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border(
                                left: BorderSide(color: pColor, width: 4)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                task.icon,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      task.subtitle,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF888888),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: PriorityHelper.labelBg(task.priority),
                                  borderRadius: BorderRadius.circular(10),
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
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}