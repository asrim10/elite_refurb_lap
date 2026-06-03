import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'name@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _confirmPasswordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({Widget? suffixIcon}) {
    return InputDecoration(
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
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Bar
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: const ShapeDecoration(
                  color: Color(0xFFF9F9F9),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFFCDC4CA),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'EliteRefurbLap',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              // Image Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 252,
                  child: Row(
                    children: [
                      // Large image
                      Expanded(
                        flex: 2,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEEEEEE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=500&fit=crop&auto=format',
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFC4B0A4),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stack) {
                              return const Center(
                                child: Icon(
                                  Icons.laptop_mac,
                                  size: 48,
                                  color: Color(0xFFC4B0A4),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Two smaller images stacked
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=200&h=240&fit=crop&auto=format',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFC4B0A4),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stack) {
                                    return const Center(
                                      child: Icon(
                                        Icons.laptop,
                                        size: 28,
                                        color: Color(0xFFC4B0A4),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=200&h=240&fit=crop&auto=format',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFC4B0A4),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stack) {
                                    return const Center(
                                      child: Icon(
                                        Icons.laptop_chromebook,
                                        size: 28,
                                        color: Color(0xFFC4B0A4),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Title & Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Join the community of premium technology.',
                      style: TextStyle(
                        color: Color(0xFF4B454A),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Full Name Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'FULL NAME',
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
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Color(0xFF6B5A50),
                          fontSize: 16,
                        ),
                        decoration: _buildInputDecoration(),
                      ),

                      const SizedBox(height: 20),

                      // Email Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'EMAIL OR PHONE',
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email or phone';
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Color(0xFF6B5A50),
                          fontSize: 16,
                        ),
                        decoration: _buildInputDecoration(),
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'SET PASSWORD',
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
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
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
                        decoration: _buildInputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFFAAAAAA),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
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
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Color(0xFF6B5A50),
                          fontSize: 16,
                        ),
                        decoration: _buildInputDecoration(
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

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        if (mounted) {
                                          setState(() => _isLoading = false);
                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Account created successfully!',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            shadowColor: Colors.black.withValues(alpha: 0.1),
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
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.6,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom "Already have an account? Sign In" bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: const ShapeDecoration(
          color: Color(0xFFF5F0EC),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Color(0xFFCDC4CA),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account? ",
              style: TextStyle(
                color: Color(0xFF4B454A),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
