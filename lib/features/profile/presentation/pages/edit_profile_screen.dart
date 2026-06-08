import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:EliteReurbLap/features/auth/presentation/state/auth_state.dart';
import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  bool _biometricEnabled = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).authEntity;
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    // Placeholder values — AuthEntity doesn't include phone/location yet
    _phoneController = TextEditingController(text: '9841234567');
    _locationController = TextEditingController(text: 'Kathmandu, Nepal');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;
    final initials = _getInitials(user?.fullName ?? 'U');

    ref.listen(authViewModelProvider, (prev, next) {
      if (prev?.status == AuthStatus.profileUpdating &&
          next.status == AuthStatus.profileUpdated) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (next.status == AuthStatus.error &&
          next.errorMessage != null &&
          prev?.status == AuthStatus.profileUpdating) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 72,
              left: 20,
              right: 20,
              bottom: 140,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo Section
                  _buildProfilePhotoSection(initials, user),
                  const SizedBox(height: 24),

                  // Form Fields
                  _buildFormFields(),

                  const SizedBox(height: 24),

                  // Account Security Section
                  _buildAccountSecuritySection(),

                  const SizedBox(height: 32),

                  // Deactivate Account
                  _buildDeactivateAccount(),
                ],
              ),
            ),
          ),

          // Bottom Save Button
          _buildBottomSaveBar(),

          // Top App Bar
          _buildTopAppBar(),
        ],
      ),
    );
  }

  Widget _buildProfilePhotoSection(String initials, AuthEntity? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      child: Column(
        children: [
          // Avatar with camera overlay
          Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Color(0xFFCDC4CA)),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    image: user?.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(user!.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: user?.imageUrl == null ? AppColors.accent : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: user?.imageUrl == null
                      ? Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              // Camera edit button
              Positioned(
                right: 4,
                bottom: 4,
                child: GestureDetector(
                  onTap: () => _onChangePhoto(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 2,
                          color: Color(0xFFF9F9F9),
                        ),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _onChangePhoto(),
            child: const Text(
              'CHANGE PHOTO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF705A4E),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      spacing: 16,
      children: [
        // Full Name
        _buildTextField(
          label: 'Full Name',
          controller: _fullNameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),

        // Email Address
        _buildTextField(
          label: 'Email Address',
          controller: _emailController,
          enabled: false,
        ),

        // Phone Number
        _buildPhoneField(),

        // Location
        _buildTextField(label: 'Location', controller: _locationController),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF848383),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.88,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 52,
          decoration: ShapeDecoration(
            color: enabled ? Colors.white : const Color(0xFFF0EAE5),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: const Color(0xFFCDC4CA)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            validator: validator,
            style: const TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              filled: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Phone Number',
              style: TextStyle(
                color: Color(0xFF848383),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.88,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 52,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  '+977',
                  style: TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(width: 1, height: 24, color: const Color(0xFFCDC4CA)),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            'Account Security',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x05050206),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Change Password
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Change Password'),
                      backgroundColor: AppColors.accent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: Color(0xFF1A1C1C),
                          ),
                          const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Color(0xFF1A1C1C),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Color(0xFFCDC4CA),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0x4CCDC4CA),
              ),
              // Biometric Authentication
              Container(
                width: double.infinity,
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 12,
                      children: [
                        const Icon(
                          Icons.fingerprint,
                          size: 20,
                          color: Color(0xFF1A1C1C),
                        ),
                        const Text(
                          'Biometric Authentication',
                          style: TextStyle(
                            color: Color(0xFF1A1C1C),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                      height: 20,
                      child: Switch.adaptive(
                        value: _biometricEnabled,
                        onChanged: (value) {
                          setState(() => _biometricEnabled = value);
                        },
                        activeThumbColor: Colors.black,
                        activeTrackColor: Colors.black.withValues(alpha: 0.5),
                        inactiveTrackColor: const Color(0xFFCDC4CA),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeactivateAccount() {
    return Center(
      child: GestureDetector(
        onTap: () => _onDeactivateAccount(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            const Icon(Icons.info_outline, size: 16, color: Color(0xFFBA1A1A)),
            const Text(
              'Deactivate Account',
              style: TextStyle(
                color: Color(0xFFBA1A1A),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSaveBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.80),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _onSaveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.black38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Container(
        height: 76,
        padding: const EdgeInsets.only(left: 8, right: 20, top: 32),
        decoration: const ShapeDecoration(
          color: Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0x4CCDC4CA)),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
            ),
            const Spacer(),
            const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.44,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  void _onChangePhoto() {
    // Future: implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Photo picker coming soon'),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onDeactivateAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Deactivate Account',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to deactivate your account? '
          'This action can be undone by contacting support.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Account deactivated'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _onSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await ref
        .read(authViewModelProvider.notifier)
        .updateProfile(fullName: _fullNameController.text.trim());
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    return 'U';
  }
}
