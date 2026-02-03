import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../services/card_service.dart';
import '../models/add_card_request.dart';
import '../widgets/notification_helper.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _agreedToTerms = false;
  bool _submitting = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Add a New\nPayment Method',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1B5D),
                ),
              ),
              const SizedBox(height: 40),

              // Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add a Payment Method',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // VISA and Mastercard logos
                      Row(
                        children: [
                          Image.asset(
                            'assets/Visa.png',
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Image.asset(
                            'assets/MasterCard.png',
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your selected payment method will be charged according to your choosen Biometric.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(height: 24),

                      // Card Number
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          _CardNumberFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Card number is required';
                          }
                          final cleanValue = value.replaceAll(' ', '');
                          if (cleanValue.length != 16) {
                            return 'Card number must be 16 digits';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          hintText: 'Card Number',
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // MM, YY, CSV Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _monthController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final month = int.tryParse(value);
                                if (month == null || month < 1 || month > 12) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                hintText: 'MM',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _yearController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final year = int.tryParse(value);
                                if (year == null || value.length != 2) {
                                  return 'Invalid';
                                }
                                final currentYear = DateTime.now().year % 100;
                                final currentMonth = DateTime.now().month;
                                final expMonth =
                                    int.tryParse(_monthController.text) ?? 0;
                                if (year < currentYear ||
                                    (year == currentYear &&
                                        expMonth < currentMonth)) {
                                  return 'Expired';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                hintText: 'YY',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (value.length != 3) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                hintText: 'CVV',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Terms Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                            fillColor: MaterialStateProperty.all(Colors.white),
                            checkColor: Colors.black,
                          ),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'By clicking, I agree to GenePay\'s ',
                                  ),
                                  TextSpan(
                                    text: 'terms and conditions',
                                    style: TextStyle(color: Color(0xFFFF5542)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Verify Card Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _agreedToTerms
                              ? () async {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  setState(() => _submitting = true);

                                  final auth = AuthService();
                                  final cardService = CardService();

                                  try {
                                    final userId = await auth
                                        .getCurrentUserId();
                                    if (userId == null)
                                      throw Exception('No logged-in user');

                                    if (auth.getToken() != null)
                                      await cardService.setAuthToken(
                                        auth.getToken()!,
                                      );

                                    final cardNumber = _cardNumberController
                                        .text
                                        .replaceAll(' ', '')
                                        .trim();
                                    final cvv = _cvvController.text.trim();
                                    final month = _monthController.text
                                        .trim()
                                        .padLeft(2, '0');
                                    final year = _yearController.text.trim();
                                    final expiry = '$month/$year';

                                    final request = AddCardRequest(
                                      cardNumber: cardNumber,
                                      cvv: cvv,
                                      expiry: expiry,
                                      setAsDefault: false,
                                    );

                                    await cardService.addUserCard(
                                      userId,
                                      request,
                                    );

                                    if (!mounted) return;
                                    NotificationHelper.showSuccess(
                                      context,
                                      'Card added successfully',
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    if (!mounted) return;
                                    NotificationHelper.showError(
                                      context,
                                      error: e,
                                    );
                                  } finally {
                                    if (mounted)
                                      setState(() => _submitting = false);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5542),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: _submitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Verify Card',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'You will be charged 5LKR to verify this card and will be refunded',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ),
                    ],
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

// Card number formatter to add spaces every 4 digits
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
