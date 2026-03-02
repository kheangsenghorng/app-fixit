import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../widgets/apple_ui_kit.dart';
import '../providers/edit_profile_provider.dart';



import 'edit_profile_form.dart.dart';
import 'edit_profile_header.dart';

class EditProfileBodyView extends ConsumerStatefulWidget {
  final int userId;
  const EditProfileBodyView({super.key, required this.userId});

  @override
  ConsumerState<EditProfileBodyView> createState() => _EditProfileBodyViewState();
}

class _EditProfileBodyViewState extends ConsumerState<EditProfileBodyView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    Future.microtask(() =>
        ref.read(editProfileProvider.notifier).loadProfile(widget.userId)
    );
  }

  void _initializeControllers(dynamic user) {
    if (!_initialized) {
      nameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phone ?? '';
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(editProfileProvider);

    // Logic to determine what overlays to show
    final bool isActionLoading = profileState.isLoading && profileState.hasValue;


    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Stack(
        children: [

          // 2. MAIN CONTENT
          profileState.when(
            loading: () => const AppleSkeletonLoader(),
            error: (e, _) => AppleErrorView(
              message: e.toString(),
              onRetry: _loadProfile,
            ),
            data: (user) {
              if (user == null) return const SizedBox.shrink();
              _initializeControllers(user);

              return Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                  child: Column(
                    children: [
                      EditProfileHeader(
                        imageUrl: user.avatar,
                        onImageTap: _pickAndUploadImage,
                      ),
                      const SizedBox(height: 40),
                      EditProfileForm(
                        nameController: nameController,
                        emailController: emailController,
                        phoneController: phoneController,
                      ),
                      const SizedBox(height: 40),
                      _buildSaveButton(isActionLoading),
                    ],
                  ),
                ),
              );
            },
          ),

          // 3. ACTION LOADING OVERLAY (HUD)
          if (isActionLoading) const AppleLoadingHUD(message: "Updating..."),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSaveButton(bool isLoading) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: AppleButton(
        label: "Save Changes",
        isLoading: isLoading,
        onPressed: _onSavePressed,
      ),
    );
  }

  // --- LOGIC METHODS ---

  Future<void> _pickAndUploadImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      ref.read(editProfileProvider.notifier).updateAvatar(
        userId: widget.userId,
        filePath: file.path,
      );
    }
  }

  void _onSavePressed() {
    ref.read(editProfileProvider.notifier).updateProfile(
      userId: widget.userId,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
    );
  }
}