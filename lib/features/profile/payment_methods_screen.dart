import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethod {
  final String id;
  final String cardholderName;
  final String cardNumber; // stored as last 4 digits or full (encrypted/masked)
  final String maskedNumber; // e.g. **** **** **** 4123
  final String expiryDate; // MM/YY
  final String brand; // Visa, Mastercard, Generic
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardholderName,
    required this.cardNumber,
    required this.maskedNumber,
    required this.expiryDate,
    required this.brand,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'cardholderName': cardholderName,
        'cardNumber': cardNumber,
        'maskedNumber': maskedNumber,
        'expiryDate': expiryDate,
        'brand': brand,
        'isDefault': isDefault,
      };

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'] as String,
        cardholderName: json['cardholderName'] as String,
        cardNumber: json['cardNumber'] as String,
        maskedNumber: json['maskedNumber'] as String,
        expiryDate: json['expiryDate'] as String,
        brand: json['brand'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  PaymentMethod copyWith({
    String? id,
    String? cardholderName,
    String? cardNumber,
    String? maskedNumber,
    String? expiryDate,
    String? brand,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      cardholderName: cardholderName ?? this.cardholderName,
      cardNumber: cardNumber ?? this.cardNumber,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      brand: brand ?? this.brand,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('velour_payment_methods');
    if (data != null) {
      try {
        final List decoded = jsonDecode(data);
        setState(() {
          _cards = decoded.map((item) => PaymentMethod.fromJson(item)).toList();
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_cards.map((item) => item.toJson()).toList());
    await prefs.setString('velour_payment_methods', data);
  }

  void _addCard(PaymentMethod card) {
    setState(() {
      if (card.isDefault || _cards.isEmpty) {
        _cards = _cards.map((item) => item.copyWith(isDefault: false)).toList();
        _cards.add(card.copyWith(isDefault: true));
      } else {
        _cards.add(card);
      }
    });
    _savePaymentMethods();
  }

  void _deleteCard(String id) {
    setState(() {
      final wasDefault = _cards.firstWhere((c) => c.id == id).isDefault;
      _cards.removeWhere((c) => c.id == id);
      if (wasDefault && _cards.isNotEmpty) {
        _cards[0] = _cards[0].copyWith(isDefault: true);
      }
    });
    _savePaymentMethods();
  }

  void _setDefaultCard(String id) {
    setState(() {
      _cards = _cards.map((item) {
        return item.copyWith(isDefault: item.id == id);
      }).toList();
    });
    _savePaymentMethods();
  }

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('PAYMENT METHODS', style: _nr(16, FontWeight.w700, cs.onSurface, ls: 2.0)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFFC1622A))))
          : Column(
              children: [
                Expanded(
                  child: _cards.isEmpty
                      ? _buildEmptyState(cs)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          itemCount: _cards.length,
                          itemBuilder: (context, index) {
                            final card = _cards[index];
                            return _buildCardItem(card, cs, isDark);
                          },
                        ),
                ),
                _buildAddButton(context, cs),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card_outlined, size: 72, color: cs.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No saved payment methods', style: _nr(20, FontWeight.w600, cs.onSurface, ls: 0.5)),
            const SizedBox(height: 8),
            Text(
              'Save your card details securely to speed up your future checkout.',
              textAlign: TextAlign.center,
              style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(PaymentMethod card, ColorScheme cs, bool isDark) {
    // Premium Credit Card look
    final cardColor = isDark ? const Color(0xFF222222) : const Color(0xFF1E1E1E);
    const textColor = Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 190,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: card.isDefault ? const Color(0xFFC1622A) : Colors.transparent,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle pattern
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              card.brand == 'Visa' ? Icons.payment : Icons.credit_card,
              size: 150,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Icon/Text
                    _getBrandIcon(card.brand, textColor),
                    if (card.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC1622A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: _bvp(10, FontWeight.w700, Colors.white, ls: 0.5),
                        ),
                      ),
                  ],
                ),
                // Card Number Masked
                Text(
                  card.maskedNumber,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: 2.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CARDHOLDER', style: _bvp(9, FontWeight.w500, Colors.white60, ls: 1.0)),
                        const SizedBox(height: 4),
                        Text(
                          card.cardholderName.toUpperCase(),
                          style: _bvp(14, FontWeight.w600, textColor),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('EXPIRES', style: _bvp(9, FontWeight.w500, Colors.white60, ls: 1.0)),
                        const SizedBox(height: 4),
                        Text(
                          card.expiryDate,
                          style: _bvp(14, FontWeight.w600, textColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (!card.isDefault)
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white60),
                            tooltip: 'Set as default',
                            onPressed: () => _setDefaultCard(card.id),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          tooltip: 'Delete card',
                          onPressed: () => _deleteCard(card.id),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBrandIcon(String brand, Color color) {
    if (brand == 'Visa') {
      return Text(
        'VISA',
        style: GoogleFonts.newsreader(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: color,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.0,
        ),
      );
    } else if (brand == 'Mastercard') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
          ),
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'mastercard',
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.credit_card, color: color),
          const SizedBox(width: 8),
          Text('CARD', style: _bvp(14, FontWeight.w700, color, ls: 1.0)),
        ],
      );
    }
  }

  Widget _buildAddButton(BuildContext context, ColorScheme cs) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.15))),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC1622A),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
        ),
        onPressed: () => _showAddCardSheet(context, cs),
        child: Text('+ Add Payment Method', style: _bvp(15, FontWeight.w600, Colors.white, ls: 0.5)),
      ),
    );
  }

  void _showAddCardSheet(BuildContext context, ColorScheme cs) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    bool isDefaultCard = _cards.isEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: cs.onSurfaceVariant.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text('ADD PAYMENT METHOD', style: _nr(18, FontWeight.w700, cs.onSurface, ls: 1.0)),
                          const SizedBox(height: 24),

                          // Cardholder Name
                          TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(labelText: 'Cardholder Name'),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter cardholder name' : null,
                          ),
                          const SizedBox(height: 16),

                          // Card Number
                          TextFormField(
                            controller: numberController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              _CardNumberFormatter(),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Card Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                            ),
                            validator: (val) {
                              if (val == null || val.replaceAll(' ', '').length < 16) {
                                return 'Please enter 16-digit card number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Expiry & CVV
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: expiryController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    _CardExpiryFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Expiry Date',
                                    hintText: 'MM/YY',
                                  ),
                                  validator: (val) {
                                    if (val == null || val.length < 5) {
                                      return 'MM/YY required';
                                    }
                                    final parts = val.split('/');
                                    if (parts.length == 2) {
                                      final month = int.tryParse(parts[0]) ?? 0;
                                      if (month < 1 || month > 12) {
                                        return 'Invalid month';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: cvvController,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'CVV',
                                    hintText: '•••',
                                  ),
                                  validator: (val) => val == null || val.length < 3 ? 'CVV' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Set Default Card Toggle
                          if (_cards.isNotEmpty)
                            CheckboxListTile(
                              title: Text('Set as default payment method', style: _bvp(14, FontWeight.w500, cs.onSurface)),
                              value: isDefaultCard,
                              activeColor: const Color(0xFFC1622A),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (val) {
                                setModalState(() {
                                  isDefaultCard = val ?? false;
                                });
                              },
                            ),
                          const SizedBox(height: 24),

                          // Save Card Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC1622A),
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                            ),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                final rawNum = numberController.text.replaceAll(' ', '');
                                String brand = 'Generic';
                                if (rawNum.startsWith('4')) {
                                  brand = 'Visa';
                                } else if (rawNum.startsWith('5')) {
                                  brand = 'Mastercard';
                                }

                                final last4 = rawNum.substring(rawNum.length - 4);
                                final masked = '•••• •••• •••• $last4';

                                final newCard = PaymentMethod(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  cardholderName: nameController.text.trim(),
                                  cardNumber: rawNum,
                                  maskedNumber: masked,
                                  expiryDate: expiryController.text,
                                  brand: brand,
                                  isDefault: isDefaultCard,
                                );
                                _addCard(newCard);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Save Card', style: _bvp(15, FontWeight.w600, Colors.white, ls: 0.5)),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Helper input formatters
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      int nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // add spacing
      }
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      int nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
