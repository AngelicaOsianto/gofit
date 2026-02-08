import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/activity_model.dart';
import '../../providers/activity_provider.dart';

class TimerScreen extends StatefulWidget {
  final ActivityModel? specificActivity;

  const TimerScreen({super.key, this.specificActivity});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  ActivityModel? _currentActivity;
  int _remainingSeconds = 0;
  int _totalSeconds = 1;
  bool _isRunning = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivityData();
    });
  }

  void _loadActivityData() {
    if (widget.specificActivity != null) {
      _setActivityData(widget.specificActivity!);
      return;
    }

    final provider = Provider.of<ActivityProvider>(context, listen: false);
    final activities = provider.activities;

    if (activities.isNotEmpty) {
      _setActivityData(activities.first);
    } else {
      _setDefaultData();
    }
  }

  void _setActivityData(ActivityModel activity) {
    setState(() {
      _currentActivity = activity;
      int minutes = activity.durationMinutes;
      if (minutes <= 0) minutes = 1;
      _totalSeconds = minutes * 60;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _setDefaultData() {
    setState(() {
      _currentActivity = null;
      _totalSeconds = 30 * 60;
      _remainingSeconds = _totalSeconds;
    });
  }

  @override
  void dispose() {
    if (_isRunning) _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int hours = _remainingSeconds ~/ 3600;
    int minutes = (_remainingSeconds % 3600) ~/ 60;
    int seconds = _remainingSeconds % 60;
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    if (hours > 0) {
      return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
    } else {
      return "${twoDigits(minutes)}:${twoDigits(seconds)}";
    }
  }

  void _toggleTimer() {
    if (_isFinished) return;

    if (_isRunning) {
      _timer.cancel();
      setState(() => _isRunning = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_remainingSeconds > 0) {
              _remainingSeconds--;
            } else {
              _timer.cancel();
              _isRunning = false;
              _isFinished = true;
              _showSuccessDialog();
            }
          });
        }
      });
      setState(() => _isRunning = true);
    }
  }

  void _resetTimer() {
    if (_isRunning) _timer.cancel();
    setState(() {
      if (_currentActivity != null) {
        _setActivityData(_currentActivity!);
      } else {
        _setDefaultData();
      }
      _isRunning = false;
      _isFinished = false;
    });
  }

  void _showSuccessDialog() {
    if (_currentActivity != null) {
      Provider.of<ActivityProvider>(context, listen: false).toggleActivityStatus(_currentActivity!.id);
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.emoji_events, color: Colors.yellow, size: 50),
            SizedBox(height: 10),
            Text("Activity Completed!", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          "Great job! You finished: ${_currentActivity?.title ?? 'Workout'}",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Finish", style: TextStyle(color: AppTheme.neonGreen, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;
    String displayTitle = _currentActivity?.title ?? "Free Workout";
    String displayType = _currentActivity?.type ?? "Timer";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: widget.specificActivity != null ? AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Timer", style: TextStyle(color: Colors.white)),
      ) : null,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.specificActivity == null)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text("Up Next", style: TextStyle(color: Colors.white54, letterSpacing: 1.5)),
                ),

              Text(
                displayTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 280, height: 280,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 8,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(
                    width: 280, height: 280,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      color: _remainingSeconds < 60 ? Colors.red : AppTheme.neonGreen,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayType.toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.neonGreen.withValues(alpha: 0.8), // Perbaikan withOpacity -> withValues
                          fontSize: 18,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _formattedTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          fontFamily: "monospace",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isFinished ? "COMPLETED" : (_isRunning ? "RUNNING" : "PAUSED"),
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _resetTimer,
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(color: Colors.grey.shade900, shape: BoxShape.circle),
                      child: const Icon(Icons.refresh, color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(width: 40),

                  GestureDetector(
                    onTap: _toggleTimer,
                    child: Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        color: _isFinished ? Colors.grey : (_isRunning ? Colors.redAccent : AppTheme.neonGreen),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRunning ? Colors.redAccent : AppTheme.neonGreen).withValues(alpha: 0.4), // Perbaikan
                            blurRadius: 15, spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.black, size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  const SizedBox(width: 60),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}