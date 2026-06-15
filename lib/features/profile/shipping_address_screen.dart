import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddress {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String provinceState;
  final String postalCode;
  final String country;
  final bool isDefault;

  ShippingAddress({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.provinceState,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'provinceState': provinceState,
        'postalCode': postalCode,
        'country': country,
        'isDefault': isDefault,
      };

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phoneNumber: json['phoneNumber'] as String,
        addressLine1: json['addressLine1'] as String,
        addressLine2: json['addressLine2'] as String?,
        city: json['city'] as String,
        provinceState: json['provinceState'] as String,
        postalCode: json['postalCode'] as String,
        country: json['country'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  ShippingAddress copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? provinceState,
    String? postalCode,
    String? country,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      provinceState: provinceState ?? this.provinceState,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  List<ShippingAddress> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('velour_shipping_addresses');
    if (data != null) {
      try {
        final List decoded = jsonDecode(data);
        setState(() {
          _addresses = decoded.map((item) => ShippingAddress.fromJson(item)).toList();
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_addresses.map((item) => item.toJson()).toList());
    await prefs.setString('velour_shipping_addresses', data);
  }

  void _addAddress(ShippingAddress address) {
    setState(() {
      if (address.isDefault || _addresses.isEmpty) {
        // Clear previous defaults
        _addresses = _addresses.map((item) => item.copyWith(isDefault: false)).toList();
        _addresses.add(address.copyWith(isDefault: true));
      } else {
        _addresses.add(address);
      }
    });
    _saveAddresses();
  }

  void _deleteAddress(String id) {
    setState(() {
      final wasDefault = _addresses.firstWhere((a) => a.id == id).isDefault;
      _addresses.removeWhere((a) => a.id == id);
      if (wasDefault && _addresses.isNotEmpty) {
        // Make the first one default if we deleted default
        _addresses[0] = _addresses[0].copyWith(isDefault: true);
      }
    });
    _saveAddresses();
  }

  void _setDefaultAddress(String id) {
    setState(() {
      _addresses = _addresses.map((item) {
        return item.copyWith(isDefault: item.id == id);
      }).toList();
    });
    _saveAddresses();
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
        title: Text('SHIPPING ADDRESSES', style: _nr(16, FontWeight.w700, cs.onSurface, ls: 2.0)),
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
                  child: _addresses.isEmpty
                      ? _buildEmptyState(cs)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          itemCount: _addresses.length,
                          itemBuilder: (context, index) {
                            final address = _addresses[index];
                            return _buildAddressCard(address, cs, isDark);
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
            Icon(Icons.local_shipping_outlined, size: 72, color: cs.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No saved addresses yet', style: _nr(20, FontWeight.w600, cs.onSurface, ls: 0.5)),
            const SizedBox(height: 8),
            Text(
              'Add your shipping details for a smoother checkout experience.',
              textAlign: TextAlign.center,
              style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(ShippingAddress address, ColorScheme cs, bool isDark) {
    final cardBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return Dismissible(
      key: Key(address.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _deleteAddress(address.id),
      child: GestureDetector(
        onTap: () => _setDefaultAddress(address.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: address.isDefault ? const Color(0xFFC1622A) : cs.outlineVariant.withValues(alpha: 0.15),
              width: address.isDefault ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(address.fullName, style: _bvp(16, FontWeight.w700, cs.onSurface)),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC1622A).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Default',
                              style: _bvp(10, FontWeight.w600, const Color(0xFFC1622A)),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(address.addressLine1, style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant)),
                    if (address.addressLine2 != null && address.addressLine2!.isNotEmpty)
                      Text(address.addressLine2!, style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant)),
                    Text('${address.city}, ${address.provinceState} ${address.postalCode}',
                        style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant)),
                    Text(address.country, style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant)),
                    const SizedBox(height: 12),
                    Text(address.phoneNumber, style: _bvp(13, FontWeight.w500, cs.onSurfaceVariant)),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      address.isDefault ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: address.isDefault ? const Color(0xFFC1622A) : cs.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    onPressed: () => _setDefaultAddress(address.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red.shade400,
                    onPressed: () => _deleteAddress(address.id),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
        onPressed: () => _showAddAddressSheet(context, cs),
        child: Text('+ Add New Address', style: _bvp(15, FontWeight.w600, Colors.white, ls: 0.5)),
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context, ColorScheme cs) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final line1Controller = TextEditingController();
    final line2Controller = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final postalController = TextEditingController();
    final countryController = TextEditingController(text: 'Sri Lanka');
    bool isDefaultAddress = _addresses.isEmpty;

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
                          Text('ADD NEW ADDRESS', style: _nr(18, FontWeight.w700, cs.onSurface, ls: 1.0)),
                          const SizedBox(height: 24),

                          // Full Name
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: 'Full Name'),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter full name' : null,
                          ),
                          const SizedBox(height: 16),

                          // Phone Number
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(labelText: 'Phone Number'),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter phone number' : null,
                          ),
                          const SizedBox(height: 16),

                          // Address Line 1
                          TextFormField(
                            controller: line1Controller,
                            decoration: const InputDecoration(labelText: 'Address Line 1'),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter address' : null,
                          ),
                          const SizedBox(height: 16),

                          // Address Line 2
                          TextFormField(
                            controller: line2Controller,
                            decoration: const InputDecoration(labelText: 'Address Line 2 (Optional)'),
                          ),
                          const SizedBox(height: 16),

                          // City & Province
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: cityController,
                                  decoration: const InputDecoration(labelText: 'City'),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'City' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: provinceController,
                                  decoration: const InputDecoration(labelText: 'Province / State'),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Province' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Postal Code & Country
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: postalController,
                                  decoration: const InputDecoration(labelText: 'Postal Code'),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Postal Code' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: countryController,
                                  decoration: const InputDecoration(labelText: 'Country'),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Country' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Default Toggle (only if list is not empty)
                          if (_addresses.isNotEmpty)
                            CheckboxListTile(
                              title: Text('Set as default address', style: _bvp(14, FontWeight.w500, cs.onSurface)),
                              value: isDefaultAddress,
                              activeColor: const Color(0xFFC1622A),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (val) {
                                setModalState(() {
                                  isDefaultAddress = val ?? false;
                                });
                              },
                            ),
                          const SizedBox(height: 24),

                          // Save Address Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC1622A),
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                            ),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                final newAddress = ShippingAddress(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  fullName: nameController.text.trim(),
                                  phoneNumber: phoneController.text.trim(),
                                  addressLine1: line1Controller.text.trim(),
                                  addressLine2: line2Controller.text.trim().isEmpty ? null : line2Controller.text.trim(),
                                  city: cityController.text.trim(),
                                  provinceState: provinceController.text.trim(),
                                  postalCode: postalController.text.trim(),
                                  country: countryController.text.trim(),
                                  isDefault: isDefaultAddress,
                                );
                                _addAddress(newAddress);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Save Address', style: _bvp(15, FontWeight.w600, Colors.white, ls: 0.5)),
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
