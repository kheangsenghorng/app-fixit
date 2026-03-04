import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/edit_profile_provider.dart';
import 'edit_profile_form.dart.dart'; 
import 'edit_profile_header.dart';

class EditProfileBodyView extends ConsumerStatefulWidget {
  final int userId;
  final Color contentColor;

  const EditProfileBodyView({
    super.key, 
    required this.userId, 
    required this.contentColor,
  });

  @override
  ConsumerState<EditProfileBodyView> createState() => _EditProfileBodyViewState();
}

class _EditProfileBodyViewState extends ConsumerState<EditProfileBodyView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    Future.microtask(() => ref.read(editProfileProvider.notifier).loadProfile(widget.userId));
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isActionLoading = profileState.isLoading && profileState.hasValue;

    return Stack(
      children: [
        profileState.when(
          loading: () => Center(child: CupertinoActivityIndicator(color: widget.contentColor)),
          error: (e, _) => Center(child: Text("Error: $e", style: TextStyle(color: widget.contentColor))),
          data: (user) {
            if (user == null) return const SizedBox.shrink();
            _initializeControllers(user);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 130, 24, 60),
              child: Column(
                children: [
                  EditProfileHeader(
                    imageUrl: user.avatar,
                    onImageTap: _pickAndUploadImage,
                    contentColor: widget.contentColor, // Pass B&W color
                  ),
                  const SizedBox(height: 50),

                  // FORM CARD (Solid B&W Style)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20)
                      ],
                    ),
                    child: EditProfileForm(
                      nameController: nameController,
                      emailController: emailController,
                      phoneController: phoneController,
                    ),
                  ),

                  const SizedBox(height: 50),
                  _buildSaveButton(isActionLoading),
                ],
              ),
            );
          },
        ),

        if (isActionLoading) _buildActionLoadingHUD(isDark),
      ],
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        onPressed: isLoading ? null : _onSavePressed,
        child: isLoading 
            ? const CupertinoActivityIndicator(color: Colors.white) 
            : const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildActionLoadingHUD(bool isDark) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          // FIX: Replaced white45/black45 with .withValues
          color: isDark 
              ? Colors.black.withValues(alpha: 0.45) 
              : Colors.white.withValues(alpha: 0.45),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoActivityIndicator(radius: 15, color: widget.contentColor),
                      const SizedBox(height: 15),
                      Text("Updating...", style: TextStyle(color: widget.contentColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      ref.read(editProfileProvider.notifier).updateAvatar(userId: widget.userId, filePath: file.path);
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