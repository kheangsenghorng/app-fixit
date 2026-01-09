import 'package:flutter/material.dart';
import 'widgets/profile_image_picker.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/phone_input_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryBlue = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. Profile Image Widget
            const Center(
              child: ProfileImagePicker(
                imageUrl: 'https://i.pravatar.cc/300',
              ),
            ),
            const SizedBox(height: 40),

            // 2. Standard Form Fields
            CustomTextField(label: "Name", hint: "Mahrama"),
            CustomTextField(label: "Email", hint: "Mahrama@gmail.com"),
            CustomTextField(
              label: "Date of Birth",
              hint: "28/11/2005",
              suffixIcon: Icons.calendar_today_outlined,
            ),
            CustomTextField(
              label: "Country",
              hint: "Mexico",
              suffixIcon: Icons.arrow_drop_down,
            ),

            // 3. Phone Number Widget
            const PhoneInputField(label: "Phone number", hint: "+92 3459864343"),

            const SizedBox(height: 40),

            // 4. Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}