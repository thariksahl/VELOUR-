import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('PRIVACY POLICY', style: _nr(16, FontWeight.w700, cs.onSurface, ls: 2.0)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VELOUR PRIVACY CHARTER',
              style: _nr(22, FontWeight.w600, cs.onSurface, ls: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: May 2026',
              style: _bvp(12, FontWeight.w500, cs.onSurfaceVariant.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 24),
            Text(
              'At VELOUR, we value your trust above all else. This Privacy Policy details how we collect, protect, and use your personal information when you use our luxury fashion application.',
              style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant, ls: 0.2),
            ),
            const SizedBox(height: 32),

            _buildSection(
              title: '1. Data Collection',
              content: 'We collect personal information that you provide to us directly when creating an account, making a purchase, or communicating with us. This includes your name, email address, physical shipping address, phone number, and payment credentials. We also collect usage data, such as items added to your wishlist or cart, to customize your shopping experience.',
              cs: cs,
            ),
            _buildSection(
              title: '2. How We Use Your Data',
              content: 'Your data enables us to process transactions quickly, ship orders to your designated shipping addresses safely, and send order tracking updates. We also use aggregated analytical information to refine our collections, personalize product recommendations, and manage promotions or price drop alerts if you choose to receive them.',
              cs: cs,
            ),
            _buildSection(
              title: '3. Third Party Sharing',
              content: 'VELOUR does not sell or lease your personal information. We share your data exclusively with reliable service partners, such as payment gateways (to process transactions securely) and courier services (to deliver your fashion packages). These parties are bound by confidentiality agreements and are permitted to use your details only to perform their specific services.',
              cs: cs,
            ),
            _buildSection(
              title: '4. Security',
              content: 'We implement robust organizational and technical security measures (including industry-standard SSL encryption and secure firewalls) to prevent unauthorized access, alteration, or disclosure of your sensitive data. Credit card information is stored locally on your device or handled directly by compliant payment processors, never stored on our central servers.',
              cs: cs,
            ),
            _buildSection(
              title: '5. Contact Us',
              content: 'If you have questions regarding this Privacy Policy, wish to request the deletion of your account data, or want to opt out of promotional messages, please reach out to our dedicated privacy support team at privacy@velour.com.',
              cs: cs,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required ColorScheme cs,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: _nr(18, FontWeight.w600, cs.onSurface, ls: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: _bvp(14, FontWeight.w400, cs.onSurfaceVariant, ls: 0.1),
          ),
        ],
      ),
    );
  }
}
