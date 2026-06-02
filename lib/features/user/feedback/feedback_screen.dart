import 'package:fixit/features/user/feedback/widgets/feedback_form.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int? bookingId;
  int? serviceId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map) {
      bookingId = args['bookingId'] as int?;
      serviceId = args['serviceId'] as int?;
    }
  }

  void _handleFeedbackSubmit(double rating, String comment) {
    debugPrint('Booking ID: $bookingId');
    debugPrint('Service ID: $serviceId');
    debugPrint('Rating: $rating');
    debugPrint('Comment: $comment');

    if (bookingId == null || serviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking ID or Service ID not found"),
        ),
      );
      return;
    }

    // TODO: Send to API here:
    // bookingId, serviceId, rating, comment

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Feedback submitted successfully!"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (bookingId == null || serviceId == null) {
      return const Scaffold(
        body: Center(
          child: Text('Invalid feedback data'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Give your feedback",
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: FeedbackForm(
        onSubmit: _handleFeedbackSubmit,
      ),
    );
  }
}