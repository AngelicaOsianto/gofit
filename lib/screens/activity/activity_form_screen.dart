import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/activity_model.dart';
import '../../providers/activity_provider.dart';
import '../../providers/notification_provider.dart';

class ActivityFormScreen extends StatefulWidget {
  static const routeName = '/activity-form';
  final String? activityId;

  const ActivityFormScreen({super.key, this.activityId});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();

  String _selectedType = 'Running';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _reminderDateTime;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.activityId != null) {
        final provider = Provider.of<ActivityProvider>(context, listen: false);
        try {
          final existingActivity = provider.activities.firstWhere((a) => a.id == widget.activityId);
          _titleController.text = existingActivity.title;
          _notesController.text = existingActivity.notes ?? '';
          _durationController.text = existingActivity.durationMinutes.toString();
          _selectedType = existingActivity.type;
          _selectedDate = existingActivity.startDate;
          _selectedTime = TimeOfDay.fromDateTime(existingActivity.startDate);
          _reminderDateTime = existingActivity.reminderTime;
        } catch (e) {
          // ignore error
        }
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    final finalStartDate = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _selectedTime.hour, _selectedTime.minute
    );

    // --- VALIDASI WAJIB: REMINDER TIDAK BOLEH LEWAT WAKTU MULAI ---
    if (_reminderDateTime != null) {
      if (_reminderDateTime!.isAfter(finalStartDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: Waktu Reminder tidak boleh melewati Waktu Mulai Latihan!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return; // STOP!
      }
    }

    final int duration = int.tryParse(_durationController.text) ?? 0;

    // ... (Sisa kode simpan sama seperti sebelumnya) ...
    // LOGIKA SIMPAN KE PROVIDER:
    if (widget.activityId == null) {
      final newActivity = ActivityModel(
        id: activityProvider.generateId(),
        title: _titleController.text,
        type: _selectedType,
        startDate: finalStartDate,
        durationMinutes: duration,
        notes: _notesController.text,
        reminderTime: _reminderDateTime,
      );
      activityProvider.addActivity(newActivity);

      if (_reminderDateTime != null) {
        notificationProvider.addNotification(
            "Reminder Set: ${_titleController.text}",
            "Don't forget to $_selectedType at ${DateFormat('HH:mm').format(_reminderDateTime!)}",
            _reminderDateTime!
        );
      }
    } else {
      bool oldStatus = false;
      try { oldStatus = activityProvider.activities.firstWhere((a) => a.id == widget.activityId).isCompleted; } catch (e) {}

      final updatedActivity = ActivityModel(
        id: widget.activityId!,
        title: _titleController.text,
        type: _selectedType,
        startDate: finalStartDate,
        durationMinutes: duration,
        notes: _notesController.text,
        reminderTime: _reminderDateTime,
        isCompleted: oldStatus,
      );
      activityProvider.updateActivity(widget.activityId!, updatedActivity);

      if (_reminderDateTime != null) {
        notificationProvider.addNotification(
            "Reminder Updated: ${_titleController.text}",
            "Schedule updated to ${DateFormat('HH:mm').format(_reminderDateTime!)}",
            _reminderDateTime!
        );
      }
    }

    Navigator.of(context).pop();
  }
  // --- Logic Date/Time Picker dan UI (Sama seperti sebelumnya, tidak diubah) ---
  // ... (Gunakan kode build() dari jawaban sebelumnya)
  // Untuk menghemat ruang, saya hanya menampilkan bagian _saveForm yang diperbaiki untuk mengatasi "Async Gap"
  // Pastikan Anda menyalin kode UI (build method) dari jawaban saya sebelumnya.

  // FUNGSI PICKER LENGKAP:
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _pickReminder() async {
    final now = DateTime.now();
    final datePicked = await showDatePicker(
      context: context,
      initialDate: _reminderDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(2030),
    );

    if (datePicked != null && mounted) {
      final timePicked = await showTimePicker(
        context: context,
        initialTime: _reminderDateTime != null
            ? TimeOfDay.fromDateTime(_reminderDateTime!)
            : TimeOfDay.now(),
      );

      if (timePicked != null) {
        setState(() {
          _reminderDateTime = DateTime(
              datePicked.year, datePicked.month, datePicked.day,
              timePicked.hour, timePicked.minute
          );
        });
      }
    }
  }

  // (Paste method deleteActivity dan Widget build dari jawaban sebelumnya di sini)
  void _deleteActivity() {
    if (widget.activityId != null) {
      Provider.of<ActivityProvider>(context, listen: false).deleteActivity(widget.activityId!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            widget.activityId == null ? "Add Activity" : "Edit Activity",
            style: const TextStyle(color: Colors.white)
        ),
        actions: [
          TextButton(
            onPressed: _saveForm,
            child: const Text("Save", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          if (widget.activityId != null)
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _deleteActivity),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Activity Title",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true, fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) => val!.isEmpty ? "Please enter a title" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Notes",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true, fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                    items: ['Running', 'Walking', 'Bike'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedType = val!),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text("Scheduling", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Date", style: TextStyle(color: Colors.green, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Time", style: TextStyle(color: Colors.green, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(_selectedTime.format(context), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Duration (minutes)",
                  labelStyle: const TextStyle(color: Colors.green),
                  filled: true, fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.timer, color: Colors.green),
                ),
                validator: (val) => val!.isEmpty ? "Enter duration" : null,
              ),

              const SizedBox(height: 24),
              const Text("Reminders", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: _pickReminder,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _reminderDateTime != null ? Colors.green : Colors.transparent)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active, color: _reminderDateTime != null ? Colors.green : Colors.grey),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _reminderDateTime == null ? "Set Reminder" : "Reminder Set For:",
                            style: TextStyle(color: _reminderDateTime == null ? Colors.white70 : Colors.green, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _reminderDateTime == null
                                ? "Tap to configure notification"
                                : DateFormat('dd MMM yyyy, HH:mm').format(_reminderDateTime!),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (_reminderDateTime != null)
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _reminderDateTime = null;
                            });
                          },
                        )
                      else
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}