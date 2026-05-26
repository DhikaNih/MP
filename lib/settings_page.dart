// lib/settings_page.dart

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State semua toggle
  bool _isTtsActive = true;
  bool _isNotifActive = true;
  bool _isDarkMode = false;
  bool _isDeadlineActive = true;
  bool _isVibrationActive = true;

  // Pilihan bahasa dan ukuran font
  String _voiceLang = 'Indonesia (Bahasa)';
  String _fontSize = 'Besar (Aksesibilitas)';

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openVoiceLangPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _PickerSheet(
        title: 'Pilih Bahasa Suara',
        options: const [
          'Indonesia (Bahasa)',
          'English (US)',
          'English (UK)',
          'Jawa (Javanese)',
        ],
        selected: _voiceLang,
        onSelect: (val) {
          setState(() => _voiceLang = val);
          _showSnackbar('Bahasa suara diubah ke $val');
        },
      ),
    );
  }

  void _openFontSizePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _PickerSheet(
        title: 'Ukuran Font',
        options: const ['Kecil', 'Normal', 'Besar (Aksesibilitas)', 'Sangat Besar'],
        selected: _fontSize,
        onSelect: (val) {
          setState(() => _fontSize = val);
          _showSnackbar('Ukuran font diubah ke $val');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  'Pengaturan',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
              ),

              // ── Accessibility Banner ──────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('♿', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Text(
                          'Aksesibilitas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Semua fitur dirancang untuk mudah diakses. '
                      'Aktifkan Text-to-Speech untuk membaca tugas dan '
                      'notifikasi secara otomatis.',
                      style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Status TTS
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isTtsActive
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _isTtsActive ? '🟢 TTS Aktif' : '🔴 TTS Nonaktif',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Suara & TTS ───────────────────────────────────────────────
              _buildSectionHeader('Suara & TTS'),
              _buildToggleRow(
                icon: '🔊',
                iconBg: const Color(0xFFDBEAFE),
                title: 'Text-to-Speech',
                subtitle: 'Baca tugas & deadline dengan suara',
                value: _isTtsActive,
                onChanged: (val) {
                  setState(() => _isTtsActive = val);
                  _showSnackbar(val ? 'TTS diaktifkan' : 'TTS dinonaktifkan');
                },
              ),
              _buildNavRow(
                icon: '🗣️',
                iconBg: const Color(0xFFE9D5FF),
                title: 'Bahasa Suara',
                subtitle: _voiceLang,
                onTap: _openVoiceLangPicker,
              ),
              _buildToggleRow(
                icon: '🔔',
                iconBg: const Color(0xFFFEF3C7),
                title: 'Notifikasi Suara',
                subtitle: 'Dering + pembacaan otomatis',
                value: _isNotifActive,
                onChanged: (val) {
                  setState(() => _isNotifActive = val);
                  _showSnackbar(val
                      ? 'Notifikasi suara diaktifkan'
                      : 'Notifikasi suara dinonaktifkan');
                },
              ),

              // ── Tampilan ──────────────────────────────────────────────────
              _buildSectionHeader('Tampilan'),
              _buildToggleRow(
                icon: '🌙',
                iconBg: const Color(0xFFD1FAE5),
                title: 'Mode Gelap',
                subtitle: 'Kontras tinggi untuk malam',
                value: _isDarkMode,
                onChanged: (val) {
                  setState(() => _isDarkMode = val);
                  _showSnackbar(val
                      ? 'Mode gelap diaktifkan'
                      : 'Mode gelap dinonaktifkan');
                },
              ),
              _buildNavRow(
                icon: '🔤',
                iconBg: const Color(0xFFDBEAFE),
                title: 'Ukuran Font',
                subtitle: _fontSize,
                onTap: _openFontSizePicker,
              ),

              // ── Notifikasi ────────────────────────────────────────────────
              _buildSectionHeader('Notifikasi'),
              _buildToggleRow(
                icon: '⏰',
                iconBg: const Color(0xFFFEE2E2),
                title: 'Pengingat Deadline',
                subtitle: '1 hari & 3 jam sebelumnya',
                value: _isDeadlineActive,
                onChanged: (val) {
                  setState(() => _isDeadlineActive = val);
                  _showSnackbar(val
                      ? 'Pengingat deadline diaktifkan'
                      : 'Pengingat deadline dinonaktifkan');
                },
              ),
              _buildToggleRow(
                icon: '📳',
                iconBg: const Color(0xFFFEF3C7),
                title: 'Getaran',
                subtitle: 'Saat notifikasi masuk',
                value: _isVibrationActive,
                onChanged: (val) {
                  setState(() => _isVibrationActive = val);
                  _showSnackbar(
                      val ? 'Getaran diaktifkan' : 'Getaran dinonaktifkan');
                },
              ),

              // ── Tentang ───────────────────────────────────────────────────
              _buildSectionHeader('Tentang'),
              _buildNavRow(
                icon: 'ℹ️',
                iconBg: const Color(0xFFF0F0F0),
                title: 'Versi Aplikasi',
                subtitle: '1.0.0 (Build 1)',
                onTap: () => _showSnackbar('Versi 1.0.0 — Dibuat dengan ❤️'),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF888888),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildIconBox(icon, iconBg),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF888888))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  Widget _buildNavRow({
    required String icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _buildIconBox(icon, iconBg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF888888))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(String icon, Color bg) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(icon, style: const TextStyle(fontSize: 18)),
    );
  }
}

// ─── Bottom sheet pilihan ─────────────────────────────────────────────────────
class _PickerSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _PickerSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...options.map((opt) => ListTile(
                title: Text(opt,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: opt == selected
                    ? const Icon(Icons.check, color: Color(0xFF2563EB))
                    : null,
                onTap: () {
                  onSelect(opt);
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )),
        ],
      ),
    );
  }
}
