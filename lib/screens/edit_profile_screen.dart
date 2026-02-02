import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../widgets/notification_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _nicController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String? _userId;

  @override
  void dispose() {
    _nameController.dispose();
    _nicController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    try {
      final auth = AuthService();
      await auth.initialize();
      final user = await auth.getCurrentUser();
      if (!mounted) return;
      _userId = user.id;
      _nameController.text = user.name ?? '';
      _nicController.text = user.nicNumber ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    } catch (e) {
      // show non-blocking error message
      if (mounted) {
        NotificationHelper.showError(context, error: e);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Edit Profile
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1B5D),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFF1E3A8A)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0A1B5D),
                      width: 3,
                    ),
                    color: const Color(0xFFE5E7EB),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xFF6B7280),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1B5D),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Edit Form
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'You can update your name and phone number. Email and NIC cannot be changed here.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                        ),
                        // Make NIC and Email read-only — only name and phone can be edited
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildEditField('Name', _nameController, readOnly: false, validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Name cannot be empty';
                                return null;
                              }),
                              _buildEditField('NIC', _nicController, readOnly: true),
                              _buildEditField('Email', _emailController, readOnly: true),
                              _buildEditField('Phone Number', _phoneController, readOnly: false, validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Phone number cannot be empty';
                                final cleaned = v.replaceAll(RegExp(r'[^0-9+]'), '');
                                if (cleaned.length < 7) return 'Enter a valid phone number';
                                return null;
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Save Changes Button
                        ElevatedButton(
                          onPressed: _saving
                              ? null
                              : () async {
                                  // Try to persist changes to backend (if supported)
                                  if (_userId == null) {
                                    NotificationHelper.showError(
                                      context,
                                      message: 'User not loaded',
                                    );
                                    return;
                                  }

                                  if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
                                    // keep form open and show errors
                                    return;
                                  }
                                  setState(() => _saving = true);
                                  try {
                                    final userService = UserService();

                                    // Initialize auth and ensure we load token from shared prefs
                                    final auth = AuthService();
                                    await auth.initialize();
                                    final token = auth.getToken();
                                    if (token != null) {
                                      await userService.setAuthToken(token);
                                    } else {
                                      // No token: user likely not authenticated
                                      throw Exception('You must be logged in to update profile');
                                    }

                                    // ONLY send allowed fields to the backend: fullName and phoneNumber
                                    final updateData = {
                                      'fullName': _nameController.text.trim(),
                                      'phoneNumber': _phoneController.text.trim(),
                                    };

                                    try {
                                      final updated = await userService
                                          .updateUser(_userId!, updateData);
                                      if (!mounted) return;
                                      NotificationHelper.showSuccess(
                                        context,
                                        'Profile updated successfully',
                                      );
                                      Navigator.pop(context, updated);
                                    } catch (e) {
                                      // Backend may not support profile update; show helpful message
                                      if (!mounted) return;
                                      NotificationHelper.showError(
                                        context,
                                        error: e,
                                        duration: const Duration(seconds: 6),
                                      );
                                    }
                                  } finally {
                                    if (mounted)
                                      setState(() => _saving = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4C3A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _saving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {bool readOnly = false, String? Function(String?)? validator}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextFormField(
              controller: controller,
              enabled: !readOnly,
              validator: validator,
                keyboardType: label.toLowerCase().contains('phone') ? TextInputType.phone : TextInputType.text,
                decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                  suffixIcon: readOnly ? const Icon(Icons.lock, size: 18, color: Color(0xFF9CA3AF)) : null,
                ),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1E3A8A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
