import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../providers/service_providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();

  String _selectedGender = 'female';
  bool _isLoading = false;

  bool get isPhoneValid {
    final cleanPhone = phoneController.text.replaceAll(RegExp(r'\D'), '');
    return cleanPhone.length == 10;
  }

  bool get isFormValid {
    final hasNames = firstNameController.text.trim().isNotEmpty && lastNameController.text.trim().isNotEmpty;
    final emailText = emailController.text.trim();
    final isEmailValid = emailText.isEmpty || RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailText);
    return hasNames && isPhoneValid && isEmailValid;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      final authService = ref.read(authServiceProvider);
      final currentPhone = authService.currentUser?.phone ?? user?.phone ?? '';

      if (currentPhone.isNotEmpty) {
        final cleanPhone = currentPhone.replaceAll('+91', '').replaceAll(RegExp(r'\D'), '');
        if (cleanPhone.length >= 10) {
          phoneController.text = cleanPhone.substring(cleanPhone.length - 10);
        } else {
          phoneController.text = cleanPhone;
        }
      }

      if (user != null) {
        if (user.firstName.isNotEmpty) firstNameController.text = user.firstName;
        if (user.lastName.isNotEmpty) lastNameController.text = user.lastName;
        if (user.email.isNotEmpty) emailController.text = user.email;
        if (user.gender.isNotEmpty && ['male', 'female', 'other'].contains(user.gender)) {
          setState(() {
            _selectedGender = user.gender;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    phoneFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final formattedPhone = '+91${phoneController.text.replaceAll(RegExp(r'\D'), '')}';

      // Send OTP to the entered mobile number
      final verificationId = await authService.signInWithPhone(formattedPhone);

      final currentAuthUser = authService.currentUser;
      final updatedUser = UserModel(
        id: currentAuthUser?.id ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
        firebaseUid: currentAuthUser?.firebaseUid ?? authService.currentUserId,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : 'rider@ecoride.app',
        phone: formattedPhone,
        gender: _selectedGender,
        isVerified: true,
        rating: 5.0,
        totalRides: 0,
        cancellationCount: 0,
        createdAt: currentAuthUser?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      // Route to OTP screen to verify code
      context.push('/otp', extra: {
        'phoneNumber': formattedPhone,
        'verificationId': verificationId,
        'isRegistration': true,
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification code: $e'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your mobile number and identity details ensure verified driver matching and Women-Only carpool safety.',
                style: TextStyle(
                  fontSize: 14.5,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Mobile Number Field (Primary)
              const Text(
                'Mobile Number *',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                focusNode: phoneFocus,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: 0.5),
                decoration: InputDecoration(
                  hintText: 'Enter 10-digit number',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14.5, fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇮🇳', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 6),
                        Text(
                          '+91',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: isPhoneValid
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 20)
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 18),

              // First & Last Name
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'First Name *',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: firstNameController,
                          focusNode: firstNameFocus,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                          decoration: InputDecoration(
                            hintText: 'Shubham',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Last Name *',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: lastNameController,
                          focusNode: lastNameFocus,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                          decoration: InputDecoration(
                            hintText: 'Patil',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Gender Selector
              const Text(
                'Gender *',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildGenderOption('female', 'Female', Icons.female_rounded),
                  const SizedBox(width: 12),
                  _buildGenderOption('male', 'Male', Icons.male_rounded),
                  const SizedBox(width: 12),
                  _buildGenderOption('other', 'Other', Icons.person_outline_rounded),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Required for verified Women-Only carpool matching filters.',
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 18),

              // Corporate / Work Email (Optional)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Work / Corporate Email',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    'Optional',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                focusNode: emailFocus,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'name@company.com (For corporate badge)',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                  prefixIcon: const Icon(Icons.business_center_outlined, size: 20, color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),

              const SizedBox(height: 36),

              // Submit CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isFormValid && !_isLoading ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verify Number & Continue',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}