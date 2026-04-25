import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_data.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _navIndex = 1; // EXPLORE is active
  int _selectedTab = 2; // "WOMEN" active

  static const Color _bg = Color(0xFFFAF9F5);
  static const Color _primary = Color(0xFF914722);
  static const Color _grayBg = Color(0x80E2E2E2); // bg-velour-gray/50
  static const Color _cardBg = Color(0xFFF4F4F0);

  final List<String> _tabs = AppData.categories.map((c) => c.label).toList();

  final List<ExploreCategory> _mainCats = AppData.exploreCategories;

  final List<CuratedSeries> _curated = AppData.curatedSeries;

  TextStyle _nr(double size, FontWeight w, Color c, {double ls = 0, bool italic = false}) =>
      GoogleFonts.newsreader(fontSize: size, fontWeight: w, color: c, letterSpacing: ls, fontStyle: italic ? FontStyle.italic : FontStyle.normal);

  TextStyle _bvp(double size, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: size, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 80 + topPad, bottom: 100 + botPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildTabs(),
                const SizedBox(height: 32),
                _buildMainCategories(),
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
        navBg: Colors.white,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _buildHeader(double topPad) {
    return Container(
      padding: EdgeInsets.only(top: topPad + 12, left: 20, right: 20, bottom: 12),
      color: _bg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, size: 24, color: _primary),
          Text('VELOUR', style: _nr(24, FontWeight.w700, const Color(0xFF1B1C1A), ls: 4.8)),
          GestureDetector(
            onTap: () => context.go(RouteNames.notifications),
            child: const Icon(Icons.notifications_outlined, size: 24, color: Color.fromARGB(255, 19, 19, 19)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: const Color(0xFFDAC1B8).withValues(alpha: 0.1)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.search, color: const Color(0xFF54433C).withValues(alpha: 0.5)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for pieces...',
                        hintStyle: _bvp(14, FontWeight.w400, const Color(0xFF54433C).withValues(alpha: 0.4)),
                      ),
                      style: _bvp(14, FontWeight.w400, const Color(0xFF1B1C1A)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              // TODO: Implement filter action
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDAC1B8).withValues(alpha: 0.1)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
              ),
              child: Icon(Icons.tune, color: const Color(0xFF54433C).withValues(alpha: 0.8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final active = i == _selectedTab;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedTab = i);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFC06C44) : _grayBg,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                _tabs[i],
                style: _bvp(13, FontWeight.w700, active ? Colors.white : const Color(0xFF1B1C1A), ls: 0.5),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<ExploreCategory> get _filteredCats {
    final tab = _tabs[_selectedTab];
    switch (tab) {
      case 'MEN':
        return [_mainCats[1], _mainCats[2]];
      case 'WOMEN':
        return [_mainCats[0], _mainCats[2]];
      case 'BEAUTY':
      case 'KIDS':
        return [_mainCats[3]];
      case 'NEW':
      default:
        return _mainCats;
    }
  }

  Widget _buildMainCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _filteredCats.map((cat) {
          return GestureDetector(
            onTap: () => context.push(RouteNames.productList),
            child: Container(
              height: 480,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    cat.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFD9D9D9),
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                      ),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: const Color(0xFFD9D9D9),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.title,
                          style: _nr(36, FontWeight.w400, Colors.white, italic: true, ls: -0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat.subtitle,
                          style: _bvp(10, FontWeight.w700, Colors.white.withValues(alpha: 0.7), ls: 3.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCuratedSeries() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Curated Series', style: _nr(30, FontWeight.w400, const Color(0xFF1B1C1A), italic: true, ls: -0.5)),
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
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.id,
                      style: _bvp(11, FontWeight.w700, _primary, ls: 3.0),
                    ),
                    Text(
                      item.title,
                      style: _bvp(18, FontWeight.w600, const Color(0xFF1B1C1A)),
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
}
