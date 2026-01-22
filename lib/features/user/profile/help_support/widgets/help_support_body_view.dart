import 'package:fixit/features/user/profile/help_support/widgets/support_illustration.dart';
import 'package:fixit/features/user/profile/help_support/widgets/support_live_chat_button.dart';
import 'package:fixit/features/user/profile/help_support/widgets/support_send_button.dart';
import 'package:fixit/features/user/profile/help_support/widgets/support_welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:fixit/features/user/profile/help_support/widgets/support_text_field.dart';

import '../controller/help_support_controller.dart';

class HelpSupportBodyView extends StatefulWidget {
  const HelpSupportBodyView({super.key});

  @override
  State<HelpSupportBodyView> createState() => _HelpSupportBodyViewState();
}

class _HelpSupportBodyViewState extends State<HelpSupportBodyView> {

  final HelpSupportController _controller = HelpSupportController();

  @override
  void dispose() {
    _controller.dispose(); // Important!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    const Color primaryBlue = Color(0xFF0056D2);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),


          // 1. Illustration
          const SupportIllustration(),
          const SizedBox(height: 10),
          // 2. Welcome Message
          const SupportWelcomeText(),
          const SizedBox(height: 30),

          // --- 2. Title Input (Using Class Widget) ---
          const SupportTextField(
            label: "Title",
            hint: "Enter the title of your issue",
            primaryColor: primaryBlue,
          ),

          // --- 3. Description Input (Using Class Widget) ---
          const SupportTextField(
            label: "Write in below box",
            hint: "Write here...",
            maxLines: 5,
            primaryColor: primaryBlue,
          ),

          const SizedBox(height: 20),

          // 4. Send Button
          SupportSendButton(
            onPressed: () {
              // Add your logic to submit the ticket here
              debugPrint("Support ticket submitted");
            },
          ),
          const SizedBox(height: 16),

          // 5. Secondary Action
          SupportLiveChatButton(
            onPressed: () => _controller.handleLiveChat(context),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}