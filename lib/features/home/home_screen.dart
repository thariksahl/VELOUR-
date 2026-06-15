import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_data.dart';
import '../../core/services/firestore_service.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

const _categoryTabs = ['WOMEN', 'MEN', 'KIDS', 'BEAUTY'];

// ── Data models ──────────────────────────────────────────────────────────────

class _EditorialBanner {
  final String imageUrl;
  final String label;
  const _EditorialBanner({required this.imageUrl, required this.label});
}

class _CollectionItem {
  final String imageUrl;
  final String name;
  /// The AppData category label used to filter MensCategoryScreen.
  final String category;
  const _CollectionItem({
    required this.imageUrl,
    required this.name,
    required this.category,
  });
}

/// Holds all content for one category tab.
class _TabContent {
  final List<_EditorialBanner> banners;
  final List<String> newInImageUrls;
  final List<_CollectionItem> collections;
  const _TabContent({
    required this.banners,
    required this.newInImageUrls,
    required this.collections,
  });
}

// ── Per-tab content map (index matches _categoryTabs) ────────────────────────

const List<_TabContent> _tabContent = [
  // ─── 0: WOMEN ────────────────────────────────────────────────────────────
  _TabContent(
    banners: [
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
        label: 'SUMMER SIGNATURES',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800',
        label: 'SUMMER OCCASIONWEAR',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1570976447640-ac859083963f?w=800',
        label: 'NEW SWIMWEAR SILHOUETTES',
      ),
    ],
    newInImageUrls: [
      // Tops
      'https://images.unsplash.com/photo-1564257631407-4deb1f99d992?w=400', // Black Off-Shoulder Top
      'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=400', // Floral Chiffon Top
      'https://images.unsplash.com/photo-1594938298603-c8148c4b4168?w=400', // White Crop Top
      'https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=400',    // Striped Knit Top
      'https://images.unsplash.com/photo-1566206091558-7f218b696731?w=400', // Pink Ruffle Top
      'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=400', // Beige Linen Top
      'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400', // Red Halter Top
      'https://images.unsplash.com/photo-1583744946564-b52ac1c389c8?w=400', // Green Wrap Top
      // Skirts
      'https://images.unsplash.com/photo-1583496661160-fb5974ca9f65?w=400', // Pleated Mini Skirt
      'https://images.unsplash.com/photo-1572804013427-4d7ca7268217?w=400', // Denim A-Line Skirt
      'https://images.unsplash.com/photo-1561677843-39dee7a319ca?w=400',    // Floral Midi Skirt
      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400', // Pink Tulle Skirt
    ],
    collections: [
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600',
        name: 'DRESSES',
        category: 'Summer',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4b4168?w=600',
        name: 'SETS',
        category: 'Tops',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=600',
        name: 'TOPS',
        category: 'Tops',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=600',
        name: 'TROUSERS',
        category: 'Jeans',
      ),
    ],
  ),

  // ─── 1: MEN ──────────────────────────────────────────────────────────────
  _TabContent(
    banners: [
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=800',
        label: 'THE MODERN WARDROBE',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4b4571?w=800',
        label: 'TAILORED ESSENTIALS',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800',
        label: 'CASUAL CLASSICS',
      ),
    ],
    newInImageUrls: [
      // Shirts (8 total in AppData)
      'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400', // White Formal Shirt
      'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400', // Blue Oxford Shirt
      'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=400', // Black Slim Shirt
      'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=400', // Striped Cotton Shirt
      'https://images.unsplash.com/photo-1620012253295-c15cc3e65df4?w=400', // Navy Linen Shirt
      'https://images.unsplash.com/photo-1589310243389-96a5483213a8?w=400', // Grey Casual Shirt
      'https://images.unsplash.com/photo-1563630423918-b58f07336ac5?w=400', // White Dress Shirt
      'https://images.unsplash.com/photo-1542060748-10c28b62716f?w=400',    // Checked Flannel Shirt
      // Jeans / Outerwear
      'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=400', // Dark Indigo Jeans
      'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=400', // Grey Straight Jeans
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',    // Classic Trench Coat
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400', // Black Skinny Jeans
    ],
    collections: [
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600',
        name: 'SHIRTS',
        category: 'Shirts',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
        name: 'T-SHIRTS',
        category: 'T-Shirts',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=600',
        name: 'TROUSERS',
        category: 'Jeans',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600',
        name: 'JACKETS',
        category: 'Outerwear',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=600',
        name: 'SUITS',
        category: 'Shirts',
      ),
    ],
  ),

  // ─── 2: KIDS ─────────────────────────────────────────────────────────────
  _TabContent(
    banners: [
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=800',
        label: 'PLAYFUL SUMMER',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800',
        label: 'BACK TO SCHOOL',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1471286174890-9c112ac6476b?w=800',
        label: 'MINI ESSENTIALS',
      ),
    ],
    newInImageUrls: [
      // All 8 Kids products from AppData (exact URLs)
      'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400', // Boys Graphic Tee
      'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=400', // Girls Floral Frock
      'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=400', // Boys Denim Shorts
      'https://images.unsplash.com/photo-1543087903-1ac2ec7aa8c5?w=400',    // Girls Pink Top
      'https://images.unsplash.com/photo-1471286174890-9c112ffca5b4?w=400', // Boys Striped Shirt
      'https://images.unsplash.com/photo-1604488573878-b5f92595c5b3?w=400', // Girls Denim Skirt
      'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=400', // Boys Hoodie
      'https://images.unsplash.com/photo-1476234251651-f353703a034d?w=400', // Girls Party Dress
      // Extend with Summer/Outerwear products for the remaining 4 slots
      'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400', // Linen Summer Dress
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', // Floral Summer Romper
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',    // Classic Trench Coat
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400', // Suede Bomber Jacket
    ],
    collections: [
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf6?w=600',
        name: 'GIRLS',
        category: 'Kids',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=600',
        name: 'BOYS',
        category: 'Kids',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1543087903-1ac2ec7aa8c5?w=600',
        name: 'NEWBORN',
        category: 'Kids',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=600',
        name: 'SHOES',
        category: 'Kids',
      ),
    ],
  ),

  // ─── 3: BEAUTY ───────────────────────────────────────────────────────────
  _TabContent(
    banners: [
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800',
        label: 'SUMMER GLOW',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=800',
        label: 'SKINCARE EDIT',
      ),
      _EditorialBanner(
        imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=800',
        label: 'FRAGRANCE COLLECTION',
      ),
    ],
    newInImageUrls: [
      // Skincare (exact imageUrls from AppData)
      'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400', // Hydrating Face Moisturizer
      'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400', // Vitamin C Serum
      'https://images.unsplash.com/photo-1526758097130-bab247274f58?w=400', // SPF 50 Sunscreen
      'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400', // Retinol Night Cream
      // Makeup
      'https://images.unsplash.com/photo-1586495777744-4e6232bf4868?w=400', // Matte Lipstick
      'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=400', // Volumising Mascara
      'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400',    // Highlighter Palette
      // Fragrance
      'https://images.unsplash.com/photo-1541643600914-78b084683702?w=400', // Floral Eau de Parfum
      'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400', // Woody Oud Cologne
      'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=400', // Fresh Citrus Mist
      // Hair
      'https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388?w=400', // Argan Oil Hair Serum
      'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab12?w=400', // Deep Conditioning Mask
    ],
    collections: [
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=600',
        name: 'SKINCARE',
        category: 'Skincare',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1586495777744-4e6232bf4868?w=600',
        name: 'MAKEUP',
        category: 'Makeup',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=600',
        name: 'FRAGRANCE',
        category: 'Fragrance',
      ),
      _CollectionItem(
        imageUrl: 'https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388?w=600',
        name: 'HAIR',
        category: 'Hair',
      ),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _navIndex = 0;

  // Firestore live stream — replaces static AppData list
  late final Stream<List<Product>> _productsStream =
      FirestoreService.instance.productsStream();

  // Fallback to local data while Firestore loads
  final List<Product> _localProducts = AppData.products();

  // ── Colour helpers ─────────────────────────────────────────────────────────

  Color _textPrimary(bool isDark) =>
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  Color _textSecondary(bool isDark) =>
      isDark ? const Color(0xFFCCCCCC) : const Color(0xFF333333);
  Color _textMuted(bool isDark) =>
      isDark ? const Color(0xFF888888) : const Color(0xFF999999);
  Color _bgPrimary(bool isDark) =>
      isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _bgPrimary(isDark),
      body: Column(
        children: [
          // ── Sticky Header ─────────────────────────────────────────────────
          _buildStickyHeader(context, isDark, cs, topPad),

          // ── Scrollable Body (Firestore-powered) ───────────────────────────
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productsStream,
              builder: (context, snap) {
                // Use Firestore data when available, fall back to local
                final products =
                    (snap.hasData && snap.data!.isNotEmpty)
                        ? snap.data!
                        : _localProducts;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1–3: Full-width editorial banners (per active tab)
                      for (final banner
                          in _tabContent[_selectedCategoryIndex].banners)
                        _EditorialSection(banner: banner, isDark: isDark),

                      const SizedBox(height: 8),

                      // Section 4: NEW IN Grid (per active tab)
                      _NewInSection(
                        isDark: isDark,
                        products: products,
                        imageUrls:
                            _tabContent[_selectedCategoryIndex].newInImageUrls,
                        textPrimary: _textPrimary(isDark),
                        textMuted: _textMuted(isDark),
                      ),

                      const SizedBox(height: 28),

                      // Section 5: SELECTED COLLECTIONS (per active tab)
                      _SelectedCollectionsSection(
                        isDark: isDark,
                        collections:
                            _tabContent[_selectedCategoryIndex].collections,
                        textPrimary: _textPrimary(isDark),
                        textSecondary: _textSecondary(isDark),
                        textMuted: _textMuted(isDark),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ── Bottom Nav ─────────────────────────────────────────────────────────
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  // ── Sticky header: greeting + icons + search + category tabs ───────────────
  Widget _buildStickyHeader(
    BuildContext context,
    bool isDark,
    ColorScheme cs,
    double topPad,
  ) {
    final textPrimary = _textPrimary(isDark);
    final textMuted = _textMuted(isDark);
    final bg = _bgPrimary(isDark);

    return Container(
      color: bg,
      padding: EdgeInsets.only(top: topPad + 12, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting row ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      () {
                        final user = FirebaseAuth.instance.currentUser;
                        final name = user?.displayName ?? user?.email ?? 'there';
                        final first = name.contains(' ')
                            ? name.split(' ').first
                            : (name.contains('@') ? name.split('@').first : name);
                        return 'Hi, $first 👋';
                      }(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textMuted,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Find your style',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go(RouteNames.notifications),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 22,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.go(RouteNames.cart),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 22,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Search bar ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(Icons.search,
                      color: textMuted, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(
                          fontSize: 13, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search for products, brands...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: textMuted,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Category tabs (WOMEN / MEN / KIDS / BEAUTY) ───────────────────
          SizedBox(
            height: 32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categoryTabs.length,
              itemBuilder: (context, i) {
                final isActive = i == _selectedCategoryIndex;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategoryIndex = i),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _categoryTabs[i],
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive
                                ? textPrimary
                                : textMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Active indicator line
                        AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 200),
                          height: 1.5,
                          width: isActive ? 24 : 0,
                          color: textPrimary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 2),

          // thin divider at bottom of header
          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFE8E8E8),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDITORIAL BANNER SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _EditorialSection extends StatelessWidget {
  final _EditorialBanner banner;
  final bool isDark;

  const _EditorialSection({
    required this.banner,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * (4 / 3);
    final bgColor =
        isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final textPrimary =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final textMuted =
        isDark ? const Color(0xFF888888) : const Color(0xFF999999);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-width image — no horizontal padding, no border radius
        SizedBox(
          width: double.infinity,
          height: imageHeight,
          child: Image.network(
            banner.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: isDark
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF0F0F0),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: isDark
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFF0F0F0),
            ),
          ),
        ),

        // Label row — white/black background, label left, SHOP NOW right
        Container(
          color: bgColor,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                banner.label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'SHOP NOW',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.underline,
                    decorationColor: textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),

        // thin separator between banners
        Divider(
          height: 1,
          thickness: 0.5,
          color: isDark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFEEEEEE),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NEW IN SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _NewInSection extends StatelessWidget {
  final bool isDark;
  final List<Product> products;
  final List<String> imageUrls;
  final Color textPrimary;
  final Color textMuted;

  const _NewInSection({
    required this.isDark,
    required this.products,
    required this.imageUrls,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Header: "NEW IN" + "VIEW ALL"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NEW IN',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  letterSpacing: 1.8,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'VIEW ALL',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: textMuted,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.underline,
                    decorationColor: textMuted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 4-column product grid, no shadows, no borders, no price
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.65,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, idx) {
              final imageUrl = imageUrls[idx];
              // Find the matching Product object by imageUrl.
              final matchedProduct =
                  products.cast<Product?>().firstWhere(
                    (p) => p!.imageUrl == imageUrl,
                    orElse: () => null,
                  );
              return GestureDetector(
                // Only navigate when the imageUrl has a matching product
                onTap: matchedProduct != null
                    ? () => context.push(
                          RouteNames.productDetailExtra,
                          extra: matchedProduct,
                        )
                    : null,
                child: _NewInProductCard(
                  imageUrl: imageUrl,
                  isDark: isDark,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NewInProductCard extends StatelessWidget {
  final String imageUrl;
  final bool isDark;

  const _NewInProductCard({
    required this.imageUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: isDark
                ? const Color(0xFF1A1A1A)
                : const Color(0xFFF2F2F2),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          color: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFF2F2F2),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SELECTED COLLECTIONS SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _SelectedCollectionsSection extends StatelessWidget {
  final bool isDark;
  final List<_CollectionItem> collections;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  const _SelectedCollectionsSection({
    required this.isDark,
    required this.collections,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'SELECTED COLLECTIONS',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textPrimary,
              letterSpacing: 2.0,
            ),
          ),

          const SizedBox(height: 14),

          // 2-column grid of collection cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemCount: collections.length,
            itemBuilder: (context, idx) {
              final col = collections[idx];
              return _CollectionCard(
                item: col,
                isDark: isDark,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                textMuted: textMuted,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final _CollectionItem item;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  const _CollectionCard({
    required this.item,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the product list screen filtered by this collection's
        // AppData category. Uses query params that MensCategoryScreen reads.
        context.push(
          '/products?category=${Uri.encodeComponent(item.category)}&title=${Uri.encodeComponent(item.name)}',
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tall editorial photo — flex takes most space
          Expanded(
            child: Image.network(
              item.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: isDark
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFF2F2F2),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: isDark
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF2F2F2),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Collection name
          Text(
            item.name,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textPrimary,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 2),

          // EXPLORE in small muted caps
          Text(
            'EXPLORE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
