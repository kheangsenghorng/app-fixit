import 'package:fixit/features/user/profile/edit/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';
// Standardize your imports based on your file structure
import 'package:fixit/features/user/profile/edit/widgets/profile_image_picker.dart';

import 'custom_text_field.dart' show CustomTextField;


class EditProfileBodyView extends StatelessWidget {
  const EditProfileBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    // It's often cleaner to define colors as constants or pull from Theme
    const Color primaryBlue = Color(0xFF0056D2);

    return SingleChildScrollView(
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
          const CustomTextField(label: "Name", hint: "Mahrama"),
          const CustomTextField(label: "Email", hint: "Mahrama@gmail.com"),
          const CustomTextField(
            label: "Date of Birth",
            hint: "28/11/2005",
            suffixIcon: Icons.calendar_today_outlined,
          ),
          const CustomTextField(
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
              onPressed: () {
                // TODO: Implement update logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
