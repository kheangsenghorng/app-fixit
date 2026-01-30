import 'dart:async';

import 'package:flutter/material.dart';

class LoadingTimerDialog extends StatefulWidget {
  const LoadingTimerDialog({super.key});

  @override
  State<LoadingTimerDialog> createState() => _LoadingTimerDialogState();
}

class _LoadingTimerDialogState extends State<LoadingTimerDialog> {
  int _seconds = 5;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 1) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text("Logging out in $_seconds seconds...",
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}