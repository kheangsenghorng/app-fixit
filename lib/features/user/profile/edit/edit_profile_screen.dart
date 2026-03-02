import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';
import '../../../../widgets/app_bar.dart';
import 'widgets/edit_profile_body_view.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const OrderAppBar(title: 'Edit Profile'),
      body: EditProfileBodyView(userId: user.id),
    );
  }
}