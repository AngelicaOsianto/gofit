import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// Import Model yang sudah dipisah tadi
import '../../models/activity_model.dart';
import '../../providers/activity_provider.dart';

class ActivityFormScreen extends StatefulWidget {
  static const routeName = '/activity-form';
  final String? activityId; // Null = Tambah Baru, Ada Isi = Edit

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
  DateTime? _reminderDateTime;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.activityId != null) {
        // --- MODE EDIT: ISI DATA LAMA ---
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
          // ID tidak ditemukan
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

    // 1. Gabungkan Date & Time
    final finalStartDate = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _selectedTime.hour, _selectedTime.minute
    );

    final int duration = int.tryParse(_durationController.text) ?? 0;

    // 2. Hitung Kalori Otomatis (Sederhana)
    double met = 4.0;
    if (_selectedType == 'Running') met = 10.0;
    if (_selectedType == 'Walking') met = 3.8;
    if (_selectedType == 'Bike') met = 8.0;
    // Rumus: MET * Berat(70kg) * (Durasi/60)
    double calculatedCalories = met * 70 * (duration / 60);
    String calorieString = "${calculatedCalories.toStringAsFixed(0)} kcal";

    // 3. Simpan Data
    if (widget.activityId == null) {
      // --- SAVE NEW ---
      final newActivity = ActivityModel(
        id: provider.generateId(),
        title: _titleController.text,
        type: _selectedType,
        startDate: finalStartDate,
        durationMinutes: duration,
        calories: calorieString, // <-- SUDAH ADA
        notes: _notesController.text,
        reminderTime: _reminderDateTime,
      );
      provider.addActivity(newActivity);
    } else {
      // --- UPDATE EXISTING ---
      bool oldStatus = false;
      try {
        oldStatus = provider.activities.firstWhere((a) => a.id == widget.activityId).isCompleted;
      } catch (e) {}

      final updatedActivity = ActivityModel(
        id: widget.activityId!,
        title: _titleController.text,
        type: _selectedType,
        startDate: finalStartDate,
        durationMinutes: duration,
        calories: calorieString, // <-- SUDAH ADA
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

  // --- Date Pickers ---
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
        title: Text(widget.activityId == null ? "Add Activity" : "Edit Activity", style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _saveForm,
            child: const Text("Save", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) => val!.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Duration (min)",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) => val!.isEmpty ? "Enter duration" : null,
              ),
              // ... (Sisa widget UI lainnya sama seperti sebelumnya) ...
            ],
          ),
        ),
      ),
    );
  }
}