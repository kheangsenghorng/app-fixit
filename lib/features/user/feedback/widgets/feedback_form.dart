import 'package:fixit/features/user/feedback/widgets/primary_button.dart';
import 'package:fixit/features/user/feedback/widgets/star_rating_bar.dart';
import 'package:flutter/material.dart';

import 'feedback_header.dart';
import 'feedback_instruction_text.dart';
import 'feedback_text_field.dart';

// Assuming primaryBlue is defined in your theme or constants
const Color primaryBlue = Color(0xFF0056D2);

class FeedbackForm extends StatefulWidget {
  final Function(double rating, String comment) onSubmit;

  const FeedbackForm({super.key, required this.onSubmit});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Reusable Header
          const FeedbackHeader(title: "How was your experience with Fix it?"),
          const SizedBox(height: 15),
          // ⭐️ STAR RATING ROW
          StarRatingBar(
            rating: _rating,
            onRatingChanged: (newRating) {
              setState(() => _rating = newRating);
            },
          ),
          const SizedBox(height: 30),
          // Reusable Instruction Text
          const FeedbackInstructionText(text: "Write in below box"),

          const SizedBox(height: 10),
          // 📝 FEEDBACK TEXT BOX
          FeedbackTextField(
            controller: _feedbackController,
            hintText: "Tell us more about your experience...",
          ),
          const Spacer(),

          PrimaryButton(
            text: "Send",
            onPressed: () => widget.onSubmit(_rating, _feedbackController.text),
            // Optional: isLoading: _isSubmitting,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}