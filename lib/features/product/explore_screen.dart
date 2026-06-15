import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/app_data.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';
import '../../core/theme/theme_notifier.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _navIndex = 1; // EXPLORE is active

  final List<ExploreCategory> _mainCats = AppData.exploreCategories;
  final List<CuratedSeries> _curated = AppData.curatedSeries;

  // ── Filter state ──────────────────────────────────────────────────────────
  RangeValues _priceRange = const RangeValues(0, 50000);
  final Set<String> _selectedSizes = {};
  final Set<String> _selectedBrands = {};

  static const List<String> _sizeOptions = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  static const List<String> _brandOptions = [
    'Zara', 'H\u0026M', 'Levi\'s', 'Nike', 'Adidas', 'Gucci', 'Prada', 'Uniqlo'
  ];
  // ─────────────────────────────────────────────────────────────────────────

  TextStyle _nr(double size, FontWeight w, Color c, {double ls = 0, bool italic = false}) =>
      GoogleFonts.newsreader(fontSize: size, fontWeight: w, color: c, letterSpacing: ls, fontStyle: italic ? FontStyle.italic : FontStyle.normal);

  TextStyle _bvp(double size, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: size, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeNotifier>();
    final theme = Theme.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 80 + topPad, bottom: 100 + botPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildAsymmetricGrid(),
                const SizedBox(height: 24),
                _buildEditorialBanner(),
                const SizedBox(height: 32),
                _buildTrendingNow(),
                const SizedBox(height: 48),
                _buildCuratedSeries(),
              ],
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(topPad),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _buildHeader(double topPad) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(top: topPad + 12, left: 20, right: 20, bottom: 12),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, size: 24, color: theme.iconTheme.color),
          Text(
            'VELOUR',
            style: _nr(
              24,
              FontWeight.w700,
              theme.textTheme.headlineLarge?.color ?? const Color(0xFF1B1C1A),
              ls: 4.8,
            ),
          ),
          GestureDetector(
            onTap: () => context.go(RouteNames.notifications),
            child: Icon(Icons.notifications_outlined, size: 24, color: theme.iconTheme.color),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.hintColor.withValues(alpha: 0.5)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for pieces...',
                        hintStyle: _bvp(14, FontWeight.w400, theme.hintColor.withValues(alpha: 0.4)),
                      ),
                      style: _bvp(14, FontWeight.w400, theme.textTheme.bodyLarge?.color ?? Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showFilterSheet(),
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: theme.cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
              ),
              child: Icon(Icons.tune, color: theme.iconTheme.color?.withValues(alpha: 0.8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsymmetricGrid() {
    final denim = _mainCats[0];
    final outerwear = _mainCats[2];
    final tailored = _mainCats[1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column: Denim & Jeans (height 180)
          Expanded(
            child: _buildCategoryCard(
              category: denim,
              height: 180,
              showNewBadge: true,
            ),
          ),
          const SizedBox(width: 16),
          // Right column: Outerwear (height 110) on top, Tailored Classics (height 60) below
          Expanded(
            child: Column(
              children: [
                _buildCategoryCard(
                  category: outerwear,
                  height: 110,
                ),
                const SizedBox(height: 10),
                _buildCategoryCard(
                  category: tailored,
                  height: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required ExploreCategory category,
    required double height,
    bool showNewBadge = false,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // Map each ExploreCategory title to its collection index (0–3)
        if (category.title == 'Denim & Jeans') {
          context.push('/explore-detail/0');
        } else if (category.title == 'Tailored Classics') {
          context.push('/explore-detail/1');
        } else if (category.title == 'Outerwear') {
          context.push('/explore-detail/2');
        } else {
          context.push('/explore-detail/0');
        }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                category.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.cardColor,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
                  ),
                ),
              ),
              // Dark gradient overlay from bottom
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.title,
                      style: _nr(height > 100 ? 18 : 14, FontWeight.w400, Colors.white, italic: true),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.subtitle,
                      style: _bvp(8, FontWeight.w700, Colors.white.withValues(alpha: 0.7), ls: 1.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showNewBadge)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'NEW',
                      style: _bvp(8, FontWeight.w700, Colors.white, ls: 1.0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditorialBanner() {
    final theme = Theme.of(context);
    final bgImage = _mainCats[1].imageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.push('/explore-detail/3'),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  bgImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.cardColor,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 36, color: Colors.grey),
                    ),
                  ),
                ),
                // Left-side dark gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.65],
                    ),
                  ),
                ),
                // Content on the left
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SUMMER EDIT',
                        style: _bvp(9, FontWeight.w700, theme.textTheme.bodyMedium?.color ?? Colors.white.withValues(alpha: 0.6), ls: 2.0),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Effortless Elegance',
                        style: _nr(18, FontWeight.w400, theme.textTheme.headlineMedium?.color ?? Colors.white, italic: true),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: theme.textTheme.bodyLarge?.color ?? Colors.white),
                        ),
                        child: Text(
                          'SHOP NOW',
                          style: _bvp(8, FontWeight.w700, theme.textTheme.bodyLarge?.color ?? Colors.black, ls: 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingNow() {
    final theme = Theme.of(context);
    final trendingChips = [
      'Linen sets',
      'Midi skirts',
      'Crop tops',
      'Wide leg',
      'Blazers',
      'Knitwear',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Trending now',
            style: _nr(24, FontWeight.w400, theme.textTheme.headlineLarge?.color ?? const Color(0xFF1B1C1A), italic: true, ls: -0.5),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: List.generate(trendingChips.length, (i) {
              final label = trendingChips[i];
              final isHighlighted = i == 0;
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isHighlighted ? const Color(0xFFC1633A) : theme.cardColor,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: isHighlighted ? const Color(0xFFC1633A) : theme.dividerColor,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  label,
                  style: _bvp(
                    12,
                    FontWeight.w600,
                    isHighlighted ? Colors.white : (theme.textTheme.bodyMedium?.color ?? const Color(0xFF1B1C1A)),
                    ls: 0.3,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCuratedSeries() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Curated Series',
            style: _nr(
              30,
              FontWeight.w400,
              theme.textTheme.headlineLarge?.color ?? const Color(0xFF1B1C1A),
              italic: true,
              ls: -0.5,
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: _curated.length,
            itemBuilder: (context, i) {
              final item = _curated[i];
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.id,
                      style: _bvp(11, FontWeight.w700, const Color(0xFFC1633A), ls: 3.0),
                    ),
                    Text(
                      item.title,
                      style: _bvp(18, FontWeight.w600, theme.textTheme.bodyLarge?.color ?? const Color(0xFF1B1C1A)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Filter Bottom Sheet ──────────────────────────────────────────────────

  void _showFilterSheet() {
    final theme = Theme.of(context);
    // Local copies so changes are only committed on "Apply Filters"
    RangeValues tempPrice = _priceRange;
    final tempSizes = Set<String>.from(_selectedSizes);
    final tempBrands = Set<String>.from(_selectedBrands);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.82,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, scrollCtrl) {
                return Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    // Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filters',
                            style: _nr(22, FontWeight.w600, theme.textTheme.headlineLarge?.color ?? const Color(0xFF1B1C1A)),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: Icon(Icons.close, size: 22, color: theme.iconTheme.color),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color: theme.dividerColor),
                    // Scrollable content
                    Expanded(
                      child: ListView(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        children: [
                          const SizedBox(height: 24),
                          // ── Price Range ────────────────────────────────
                          Text(
                            'Price Range',
                            style: _bvp(13, FontWeight.w700, theme.textTheme.titleMedium?.color ?? const Color(0xFF1B1C1A), ls: 0.6),
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: const Color(0xFFC1633A),
                              inactiveTrackColor: theme.dividerColor,
                              thumbColor: const Color(0xFFC1633A),
                              overlayColor: const Color(0xFFC1633A).withValues(alpha: 0.15),
                              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
                              trackHeight: 3,
                            ),
                            child: RangeSlider(
                              values: tempPrice,
                              min: 0,
                              max: 50000,
                              divisions: 500,
                              onChanged: (v) => setSheetState(() => tempPrice = v),
                            ),
                          ),
                          Center(
                            child: Text(
                              'LKR ${tempPrice.start.toStringAsFixed(0)} – LKR ${tempPrice.end.toStringAsFixed(0)}',
                              style: _bvp(13, FontWeight.w500, theme.textTheme.bodyMedium?.color ?? const Color(0xFF54433C)),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Divider(height: 1, thickness: 1, color: theme.dividerColor),
                          const SizedBox(height: 24),
                          // ── Size ──────────────────────────────────────
                          Text(
                            'Size',
                            style: _bvp(13, FontWeight.w700, theme.textTheme.titleMedium?.color ?? const Color(0xFF1B1C1A), ls: 0.6),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _sizeOptions.map((size) {
                              final selected = tempSizes.contains(size);
                              return GestureDetector(
                                onTap: () => setSheetState(() {
                                  selected ? tempSizes.remove(size) : tempSizes.add(size);
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected ? const Color(0xFFC1633A) : theme.cardColor,
                                    borderRadius: BorderRadius.circular(99),
                                    border: Border.all(
                                      color: selected ? const Color(0xFFC1633A) : theme.dividerColor,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Text(
                                    size,
                                    style: _bvp(13, FontWeight.w600,
                                        selected ? Colors.white : (theme.textTheme.bodyMedium?.color ?? const Color(0xFF1B1C1A))),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 28),
                          Divider(height: 1, thickness: 1, color: theme.dividerColor),
                          const SizedBox(height: 24),
                          // ── Brand ─────────────────────────────────────
                          Text(
                            'Brand',
                            style: _bvp(13, FontWeight.w700, theme.textTheme.titleMedium?.color ?? const Color(0xFF1B1C1A), ls: 0.6),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _brandOptions.map((brand) {
                              final selected = tempBrands.contains(brand);
                              return GestureDetector(
                                onTap: () => setSheetState(() {
                                  selected ? tempBrands.remove(brand) : tempBrands.add(brand);
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected ? const Color(0xFFC1633A) : theme.cardColor,
                                    borderRadius: BorderRadius.circular(99),
                                    border: Border.all(
                                      color: selected ? const Color(0xFFC1633A) : theme.dividerColor,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Text(
                                    brand,
                                    style: _bvp(13, FontWeight.w600,
                                        selected ? Colors.white : (theme.textTheme.bodyMedium?.color ?? const Color(0xFF1B1C1A))),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    // ── Action buttons ────────────────────────────────────
                    Divider(height: 1, thickness: 1, color: theme.dividerColor),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          24, 16, 24, 16 + MediaQuery.of(ctx).padding.bottom),
                      child: Row(
                        children: [
                          // Clear All (outlined)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setSheetState(() {
                                  tempPrice = const RangeValues(0, 50000);
                                  tempSizes.clear();
                                  tempBrands.clear();
                                });
                              },
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(color: const Color(0xFFC1633A), width: 1.5),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Clear All',
                                  style: _bvp(14, FontWeight.w600, const Color(0xFFC1633A)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Apply Filters (filled)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _priceRange = tempPrice;
                                  _selectedSizes
                                    ..clear()
                                    ..addAll(tempSizes);
                                  _selectedBrands
                                    ..clear()
                                    ..addAll(tempBrands);
                                });
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC1633A),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Apply Filters',
                                  style: _bvp(14, FontWeight.w600, Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
