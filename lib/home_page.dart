// lib/home_page.dart

import 'package:flutter/material.dart';
import 'app_state.dart';
import 'task_model.dart';
import 'widgets/task_item_widget.dart';
import 'widgets/edit_task_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openEditTask(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditTaskSheet(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final important = state.importantTasks;
    final pending = state.pendingTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header (unchanged)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Halo, Dara 👋',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Ada ${pending.length} tugas menunggu hari ini',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF888888)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🔊 Fitur TTS akan segera hadir!'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.volume_up,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Summary Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    _SummaryCard(
                        number: '${pending.length}', label: 'Tugas Aktif'),
                    const SizedBox(width: 12),
                    _SummaryCard(
                        number: '${state.importantTasks.length}',
                        label: 'Deadline'),
                    const SizedBox(width: 12),
                    const _SummaryCard(number: '1', label: 'Ujian'),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Prioritas Tinggi
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 20, bottom: 12),
                child: Text(
                  '🎯 Prioritas Tinggi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: important.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Text('🎉', style: TextStyle(fontSize: 32)),
                              SizedBox(height: 8),
                              Text(
                                'Tidak ada tugas penting!',
                                style: TextStyle(
                                    color: Color(0xFF888888), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: important
                            .asMap()
                            .entries
                            .map(
                              (e) => TaskItemWidget(
                                task: e.value,
                                isLast: e.key == important.length - 1,
                                onToggle: () =>
                                    state.toggleDone(e.value.id),
                                onDelete: () =>
                                    state.deleteTask(e.value.id),
                                onEdit: () =>
                                    _openEditTask(context, e.value),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),

            // Semua Tugas
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  '📋 Semua Tugas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: state.tasks.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Belum ada tugas. Tekan + untuk menambah!',
                            style: TextStyle(
                                color: Color(0xFF888888), fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Column(
                        children: state.tasks
                            .asMap()
                            .entries
                            .map(
                              (e) => TaskItemWidget(
                                task: e.value,
                                isLast: e.key == state.tasks.length - 1,
                                onToggle: () =>
                                    state.toggleDone(e.value.id),
                                onDelete: () =>
                                    state.deleteTask(e.value.id),
                                onEdit: () =>
                                    _openEditTask(context, e.value),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Tekan tugas untuk tandai selesai ✓\nGeser ke kiri untuk hapus 🗑️\nTekan lama untuk edit ✏️',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String number;
  final String label;

  const _SummaryCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}