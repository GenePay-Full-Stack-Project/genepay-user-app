import 'package:flutter/material.dart';
import 'add_payment_method_screen.dart';
import 'face_enrollment_screen.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/card_service.dart';
import '../services/payment_service.dart';
import '../models/user.dart';
import '../models/card_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _showBiometrics = false;
  bool _loading = true;
  bool _cardsLoading = false;
  bool _totalSpendsLoading = false;
  User? _user;
  List<CardModel> _cards = [];
  double? _totalSpends;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCards();
    _loadTotalSpends();
  }

  Future<void> _loadUser() async {
    final auth = AuthService();
    final userService = UserService();
    try {
      final id = await auth.getCurrentUserId();
      if (id != null) {
        final token = auth.getToken();
        if (token != null) {
          await userService.setAuthToken(token);
        }
        final user = await userService.getUserById(id);
        setState(() {
          _user = user;
        });
      }
    } catch (_) {
      // ignore
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadCards() async {
    setState(() => _cardsLoading = true);
    final auth = AuthService();
    final cardService = CardService();
    try {
      final id = await auth.getCurrentUserId();
      if (id != null) {
        final token = auth.getToken();
        if (token != null) {
          await cardService.setAuthToken(token);
        }
        final cards = await cardService.getUserCards(id);
        setState(() {
          _cards = cards;
        });
      }
    } catch (e) {
      // Show error if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cards: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _cardsLoading = false);
    }
  }

  Future<void> _loadTotalSpends() async {
    setState(() => _totalSpendsLoading = true);
    final auth = AuthService();
    final paymentService = PaymentService();
    try {
      final id = await auth.getCurrentUserId();
      if (id != null) {
        final token = auth.getToken();
        if (token != null) {
          await paymentService.setAuthToken(token);
        }
        final totalSpends = await paymentService.getUserTotalSpends(id);
        setState(() {
          _totalSpends = totalSpends;
        });
      }
    } catch (e) {
      // Show error if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load total spends: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _totalSpendsLoading = false);
    }
  }

  Future<void> _setDefaultCard(CardModel card) async {
    final auth = AuthService();
    final cardService = CardService();
    try {
      final id = await auth.getCurrentUserId();
      if (id == null || card.id == null) return;

      final token = auth.getToken();
      if (token != null) {
        await cardService.setAuthToken(token);
      }

      await cardService.setUserDefaultCard(id, card.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Default card updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCards(); // Reload cards to update UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set default card: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  Future<void> _deleteFace() async {
    final auth = AuthService();
    final userService = UserService();

    try {
      final userId = await auth.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final token = auth.getToken();
      if (token != null) {
        await userService.setAuthToken(token);
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF5542)),
        ),
      );

      // Delete face from user account
      await userService.deleteFace(userId);

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Reload user data
      await _loadUser();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face biometric removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove face: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Manage your Wallet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1B5D),
                    ),
                  ),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: LinearProgressIndicator(),
                    )
                  else ...[
                    const SizedBox(height: 8),
                    Text(
                      _user?.email ?? 'No user information',
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ],
                ],
              ),
            ),

            // Expenses Card
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // Use the Visa card image as a background instead of the orange gradient
                  image: DecorationImage(
                    image: AssetImage('assets/visacard.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Spends',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_totalSpendsLoading)
                          const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        else
                          Text(
                            _totalSpends?.toStringAsFixed(2) ?? '0.00',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'LKR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Payment Methods Section
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  border: Border.all(color: const Color(0xFFFF4C3A), width: 5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTabButton(
                            'Linked Payment\nMethods',
                            !_showBiometrics,
                          ),
                          _buildTabButton('Linked Biometrics', _showBiometrics),
                        ],
                      ),
                    ),

                    Expanded(
                      child: _showBiometrics
                          ? _buildBiometricsView()
                          : _buildPaymentMethodsView(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showBiometrics = text.contains('Biometrics');
        });
      },
      child: Container(
        width: 150,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4C3A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFF4C3A), width: 1.5),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFFF4C3A),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        // Show loading indicator
        if (_cardsLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          )
        // Show empty state
        else if (_cards.isEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Text('No payment methods linked'),
          )
        // Show cards from API
        else
          ..._cards.map(
            (card) => _buildPaymentCard(
              card.cardBrand ?? 'Card',
              '**** ${card.cardLast4 ?? ''}',
              card.isDefault ?? false,
              card,
            ),
          ),
        const SizedBox(height: 16),

        // Separator line
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(color: Colors.grey.shade300, thickness: 1),
        ),

        // Add New Payment Method Button
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPaymentMethodScreen(),
              ),
            );
            // Reload cards if a card was added
            if (result == true) {
              _loadCards();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFFF4C3A),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Add a New Payment Method',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricsView() {
    final hasFace = _user?.faceEnrolled == true;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        // Show face enrollment status
        if (hasFace)
          _buildBiometricCard(
            'Face Recognition',
            'Active and Verified',
            Icons.face,
          )
        else
          _buildEmptyBiometricCard(),

        const SizedBox(height: 16),

        // Add New Biometric Button - only show if no face enrolled
        if (!hasFace)
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FaceEnrollmentScreen(),
                ),
              );
              if (result == true && mounted) {
                await _loadUser();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Color(0xFFFF4C3A), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Add a New Biometric',
                    style: TextStyle(
                      color: Color(0xFFFF4C3A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBiometricCard(String label, String status, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4C3A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFFF4C3A), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFFF4C3A)),
            onPressed: () => _showDeleteFaceConfirmation(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBiometricCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.face_retouching_off,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No face registered',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteFaceConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Face'),
        content: const Text(
          'Are you sure you want to remove your registered face?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFace();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF4C3A),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    String type,
    String number,
    bool isDefault,
    CardModel card,
  ) {
    // Determine image path based on card brand
    String? imagePath;
    if (type.toLowerCase().contains('visa')) {
      imagePath = 'assets/Visa.png';
    } else if (type.toLowerCase().contains('master')) {
      imagePath = 'assets/MasterCard.png';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDefault ? const Color(0xFFFF4C3A) : const Color(0xFFE5E7EB),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox for default card
          GestureDetector(
            onTap: () => _setDefaultCard(card),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDefault ? const Color(0xFFFF4C3A) : Colors.transparent,
                border: Border.all(
                  color: isDefault
                      ? const Color(0xFFFF4C3A)
                      : const Color(0xFFE5E7EB),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isDefault
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 16),

          // Card brand logo
          Container(
            width: 60,
            height: 40,
            padding: imagePath != null
                ? const EdgeInsets.all(6)
                : const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: imagePath != null
                ? Image.asset(imagePath, fit: BoxFit.contain)
                : const Icon(
                    Icons.account_balance,
                    color: Color(0xFF333333),
                    size: 24,
                  ),
          ),
          const SizedBox(width: 20),

          // Card number
          Expanded(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
