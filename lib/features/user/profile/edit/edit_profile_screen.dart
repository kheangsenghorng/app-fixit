import 'package:fixit/features/user/profile/edit/widgets/edit_profile_body_view.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/app_bar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const OrderAppBar(title: 'Edit Profile'),
      body: const EditProfileBodyView(),
    );
  }
}