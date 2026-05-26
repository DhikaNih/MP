// lib/widgets/edit_task_sheet.dart
// Bottom sheet untuk mengedit tugas

import 'package:flutter/material.dart';
import '../app_state.dart';
import '../task_model.dart';
import '../priority_helper.dart';

class EditTaskSheet extends StatefulWidget {
  final Task task;

  const EditTaskSheet({super.key, required this.task});

  @override
  State<EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _subCtrl;
  late String _priority;
  late String _icon;
  late DateTime? _dueDate;
  final _formKey = GlobalKey<FormState>();

  static const _icons = ['📄', '🧮', '🔬', '📖', '💻', '🎨', '📊', '🔭', '🏃', '✏️'];
  static const _priorities = ['Penting', 'Sedang', 'Rendah'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title);
    _subCtrl = TextEditingController(text: widget.task.subtitle);
    _priority = widget.task.priority;
    _icon = widget.task.icon;
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _clearDueDate() {
    setState(() => _dueDate = null);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    AppStateScope.of(context).updateTask(
      id: widget.task.id,
      icon: _icon,
      iconBg: PriorityHelper.defaultIconBg(_priority),
      title: _titleCtrl.text.trim(),
      subtitle: _subCtrl.text.trim().isEmpty
          ? 'Belum ada keterangan'
          : _subCtrl.text.trim(),
      priority: _priority,
      dueDate: _dueDate,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Tugas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),

              // Judul
              _label('Judul Tugas'),
              TextFormField(
                controller: _titleCtrl,
                decoration: _inputDecoration('Contoh: Essay Matematika'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 14),

              // Keterangan
              _label('Keterangan (opsional)'),
              TextFormField(
                controller: _subCtrl,
                decoration: _inputDecoration('Contoh: 25 Mei, 23:59 • 10 soal'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 14),

              // Prioritas
              _label('Prioritas'),
              Row(
                children: _priorities.map((p) {
                  final selected = _priority == p;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _priority = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? PriorityHelper.labelBg(p)
                              : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(20),
                          border: selected
                              ? Border.all(
                                  color: PriorityHelper.labelColor(p),
                                  width: 1.5)
                              : null,
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? PriorityHelper.labelColor(p)
                                : const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Tanggal Jatuh Tempo
              _label('Tanggal Jatuh Tempo (opsional)'),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDueDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 18, color: Color(0xFF2563EB)),
                            const SizedBox(width: 8),
                            Text(
                              _dueDate == null
                                  ? 'Pilih tanggal'
                                  : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                              style: TextStyle(
                                color: _dueDate == null
                                    ? const Color(0xFFBBBBBB)
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_dueDate != null)
                    TextButton(
                      onPressed: _clearDueDate,
                      child: const Text('Hapus',
                          style: TextStyle(color: Color(0xFFDC2626))),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Pilih ikon
              _label('Ikon'),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _icons.map((ic) {
                    final selected = _icon == ic;
                    return GestureDetector(
                      onTap: () => setState(() => _icon = ic),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(ic, style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol aksi
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                            color: Color(0xFF444444), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF666666)),
        ),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
      );
}