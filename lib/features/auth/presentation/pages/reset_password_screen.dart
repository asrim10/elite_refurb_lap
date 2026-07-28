import 'package:EliteReurbLap/features/auth/presentation/state/auth_state.dart';
import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? initialToken;

  const ResetPasswordScreen({super.key, this.initialToken});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _tokenController =
      TextEditingController(text: widget.initialToken);
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool get _isLoading =>
      ref.watch(authViewModelProvider).status == AuthStatus.loading;

  @override
  void initState() {
    super.initState();
    _tryExtractTokenFromUrl();
  }

  void _tryExtractTokenFromUrl() {
    if (_tokenController.text.isNotEmpty) return;
    try {
      final uri = Uri.base;
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        _tokenController.text = token;
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
      if (prev != null && prev.status == AuthStatus.loading) {
        if (next.status == AuthStatus.passwordResetSuccess) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password has been reset successfully!'),
              backgroundColor: Color(0xFF2D6A3F),
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (!mounted) return;
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        } else if (next.status == AuthStatus.error &&
            next.errorMessage != null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Key Icon
              Container(
                width: 80,
                height: 80,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE8E0D8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Icon(
                  Icons.vpn_key_rounded,
                  size: 40,
                  color: Color(0xFF6B5A50),
                ),
              ),
              const SizedBox(height: 28),

              // Title
              const Text(
                'Set New Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter the reset token from your email and choose a new password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF848383),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Token Field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RESET TOKEN',
                        style: TextStyle(
                          color: Color(0xFF4B454A),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.88,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tokenController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the reset token from your email';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: Color(0xFF6B5A50),
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Paste your reset token here',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 14,
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFC4B0A4),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFC4B0A4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // New Password Field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'NEW PASSWORD',
                        style: TextStyle(
                          color: Color(0xFF4B454A),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.88,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: Color(0xFF6B5A50),
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'At least 6 characters',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 16,
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFC4B0A4),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFC4B0A4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE53935),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFFAAAAAA),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CONFIRM PASSWORD',
                        style: TextStyle(
                          color: Color(0xFF4B454A),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.88,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: Color(0xFF6B5A50),
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Re-enter your new password',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 16,
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFC4B0A4),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFC4B0A4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE53935),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFFAAAAAA),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(authViewModelProvider.notifier)
                                      .resetPassword(
                                        token:
                                            _tokenController.text.trim(),
                                        newPassword:
                                            _newPasswordController.text,
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          disabledBackgroundColor:
                              Colors.black.withValues(alpha: 0.7),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'RESET PASSWORD',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Back to Login
              TextButton(
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false),
                child: const Text(
                  'Back to Sign In',
                  style: TextStyle(
                    color: Color(0xFF6B5A50),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
