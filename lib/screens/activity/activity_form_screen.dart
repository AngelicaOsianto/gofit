// Lokasi: lib/screens/activity/activity_form_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/activity_model.dart';
import '../../providers/activity_provider.dart';

class ActivityFormScreen extends StatefulWidget {
  static const routeName = '/activity-form';

  // Jika null = Mode Tambah. Jika ada isi = Mode Edit.
  final String? activityId;

  const ActivityFormScreen({super.key, this.activityId});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();

  // State Variables
  String _selectedType = 'Running';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Variabel untuk Reminder
  DateTime? _reminderDateTime;

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.activityId != null) {
        // --- MODE EDIT: ISI DATA LAMA ---
        final provider = Provider.of<ActivityProvider>(context, listen: false);

        try {
          // Cari activity berdasarkan ID
          final existingActivity = provider.activities.firstWhere((a) => a.id == widget.activityId);

          _titleController.text = existingActivity.title;
          _notesController.text = existingActivity.notes ?? '';
          _durationController.text = existingActivity.durationMinutes.toString();
          _selectedType = existingActivity.type;
          _selectedDate = existingActivity.startDate;
          _selectedTime = TimeOfDay.fromDateTime(existingActivity.startDate);

          // Load Reminder jika ada
          _reminderDateTime = existingActivity.reminderTime;

        } catch (e) {
          // Jika ID tidak ditemukan (aman)
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

    final provider = Provider.of<ActivityProvider>(context, listen: false);

    // Gabungkan Date & Time
    final finalStartDate = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _selectedTime.hour, _selectedTime.minute
    );

    final int duration = int.tryParse(_durationController.text) ?? 0;

    if (widget.activityId == null) {
      // --- SAVE NEW ---
      final newActivity = ActivityModel(
        id: provider.generateId(),
        title: _titleController.text,
        type: _selectedType,
        startDate: finalStartDate,
        durationMinutes: duration,
        notes: _notesController.text,
        reminderTime: _reminderDateTime,
      );
      provider.addActivity(newActivity);
    } else {
      // --- UPDATE EXISTING ---
      bool oldStatus = false;
      try {
        oldStatus = provider.activities.firstWhere((a) => a.id == widget.activityId).isCompleted;
      } catch (e) { /* ignore */ }

      final updatedActivity = ActivityModel(
        id: widget.activityId!, // Dijamin tidak null karena masuk blok else
        title: _titleController.text,
        type: _selectedType,
        startDate: finalStartDate,
        durationMinutes: duration,
        notes: _notesController.text,
        reminderTime: _reminderDateTime,
        isCompleted: oldStatus,
      );
      provider.updateActivity(widget.activityId!, updatedActivity);
    }

    Navigator.of(context).pop();
  }

  void _deleteActivity() {
    if (widget.activityId != null) {
      Provider.of<ActivityProvider>(context, listen: false).deleteActivity(widget.activityId!);
      Navigator.of(context).pop();
    }
  }

  // --- Date Picker Logic ---
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

  // --- Logic Khusus Reminder (Date + Time) ---
  Future<void> _pickReminder() async {
    final now = DateTime.now();
    final datePicked = await showDatePicker(
      context: context,
      initialDate: _reminderDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(2030),
    );

    if (datePicked != null) {
      // ignore: use_build_context_synchronously
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
              // Title
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Activity Title",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) => val!.isEmpty ? "Please enter a title" : null,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Notes",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              // Type Dropdown
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

              // Date & Time Picker (Start Date)
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

              // Duration
              TextFormField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Duration (minutes)",
                  labelStyle: const TextStyle(color: Colors.green),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.timer, color: Colors.green),
                ),
                validator: (val) => val!.isEmpty ? "Enter duration" : null,
              ),

              const SizedBox(height: 24),
              const Text("Reminders", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // --- REMINDER PICKER TOOL ---
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