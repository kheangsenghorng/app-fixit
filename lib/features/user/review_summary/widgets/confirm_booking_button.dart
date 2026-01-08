import 'package:flutter/material.dart';


class ConfirmBookingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmBookingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          child: const Text("Confirm Booking"),
        ),
      ),
    );
  }
}
