import 'package:flutter/material.dart';

class HelpSupportController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Logic for Live Chat
  void handleLiveChat(BuildContext context) {
    final initialIssue = titleController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(initialIssue.isEmpty
            ? "Connecting to a live agent..."
            : "Connecting regarding: $initialIssue"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0056D2),
      ),
    );

    // Navigation logic
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
  }

  // Logic for Sending Ticket
  void handleSend(BuildContext context) {
    if (titleController.text.isEmpty) {
      // Handle error
      return;
    }
  }

  // Always dispose controllers to prevent memory leaks
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }
}