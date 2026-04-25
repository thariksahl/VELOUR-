# VELOUR — Project Blueprint
> Complete technical & non-technical reference for all current code, logic, navigation, UI, bugs, and future work.
> Last updated: April 25, 2026

---

## 1. What Is This App?

VELOUR is a **luxury fashion e-commerce Flutter app** (prototype/MVP stage). It lets users browse clothes, add to cart, wishlist items, and place orders. Authentication is fake (no real backend). All data is hardcoded in memory.

**Tech Stack**
- Flutter (Dart)
- go_router — URL-based navigation
- provider — Auth state only
- google_fonts — Newsreader + Be Vietnam Pro
- No backend, no Firebase, no local DB

---

## 2. Folder Structure

```
lib/
├── main.dart                        # App entry point
├── config/                          # (empty / unused)
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Design tokens (partially used)
│   │   ├── app_sizes.dart           # Spacing constants (partially used)
│   │   └── app_strings.dart         # String constants (partially used)
│   ├── theme/app_theme.dart         # ThemeData (NOT wired into main.dart)
│   ├── utils/                       # (contents unknown, likely empty)
│   └── widgets/
│       ├── category_chip.dart       # Reusable chip (not used by most screens)
│       └── custom_button.dart       # Reusable button (not used by most screens)
├── data/
│   ├── models.dart                  # All data models
│   └── app_data.dart                # All hardcoded data + cart state
├── routes/
│   ├── route_names.dart             # Route path constants
│   └── app_router.dart              # GoRouter config + transitions
├── features/
│   ├── auth/
│   │   ├── user_model.dart
│   │   ├── auth_repository.dart     # Fake login/signup
│   │   ├── auth_provider.dart       # ChangeNotifier
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── splash/splash_screen.dart
│   ├── home/home_screen.dart
│   ├── product/
│   │   ├── explore_screen.dart
│   │   ├── product_list_screen.dart # Named MensCategoryScreen internally
│   │   └── product_detail_screen.dart
│   ├── cart/cart_screen.dart
│   ├── wishlist/wishlist_screen.dart
│   ├── profile/profile_screen.dart
│   ├── notifications/notifications_screen.dart
│   └── orders/
│       ├── orders_screen.dart       # STUB — only shows "Coming Soon"
│       └── order_confirmation_screen.dart
└── screen/                          # (unknown, possibly legacy/unused)
```

---

## 3. Data Models (`lib/data/models.dart`)

| Model | Fields | Notes |
|---|---|---|
| `Product` | name, description, price, imageUrl, category, wishlisted | `wishlisted` is mutable |
| `Category` | label | Used for nav chips |
| `SubCategory` | label, imageUrl | Circular icons |
| `ExploreCategory` | title, subtitle, imageUrl | Large cards in explore |
| `CuratedSeries` | id, title | Grid cards in explore |
| `WishlistItem` | name, price, imageUrl, wishlisted | Separate from Product |
| `CartItem` | name, variant, price, imageUrl, qty | qty is mutable |
| `NotificationItem` | icon, iconColor, bgColor, title, subtitle, time, isUnread, isFadedText | |
| `OrderSummaryItem` | name, variant, price, imageUrl | Used only in order confirmation |

---

## 4. Centralized Data (`lib/data/app_data.dart`)

```dart
AppData.categories          // 5 items: NEW, MEN, WOMEN, BEAUTY, KIDS
AppData.subCategories       // 8 items: Shirts, Tops, Jeans, etc.
AppData.products()          // 11 products (returns new list each call)
AppData.exploreCategories   // 4 items
AppData.curatedSeries       // 4 items
AppData.wishlistItems()     // 4 items (returns new list each call)
AppData.cartItems()         // Returns _cartItemsList (shared mutable reference)
AppData.addToCart(item)     // Appends to _cartItemsList
AppData.notifications()     // 5 items
AppData.orderSummaryItems   // 2 items (const, hardcoded, NOT from cart)
```

> ⚠️ **Critical Bug**: `products()` and `wishlistItems()` return **new lists each call** — so mutations (wishlisted toggle) may not persist across widget rebuilds that call these again. `cartItems()` returns the shared `_cartItemsList` reference, which is correct.

---

## 5. Auth Flow

```
App Start
  └─► SplashScreen (fade transition)
        └─► AuthProvider.init() called in main.dart
              ├─ No current user → LoginScreen
              └─ Has user → HomeScreen

LoginScreen
  └─► AuthProvider.login(email, password)
        ├─ Success → GoRouter redirects to /home (any email works, no validation)
        └─ Failure → shows error message

SignupScreen
  └─► AuthProvider.signup(firstName, lastName, email, password)
        └─ Success → GoRouter redirects to /home

ProfileScreen → "LOG OUT" button
  └─► context.go(RouteNames.login)  ⚠️ DOES NOT call AuthProvider.logout()
```

**Auth is purely in-memory.** Closing and reopening the app always starts unauthenticated.

---

## 6. Route Map (`lib/routes/app_router.dart`)

| Route Name | Path | Screen | Transition |
|---|---|---|---|
| `splash` | `/` | SplashScreen | fade 400ms |
| `login` | `/login` | LoginScreen | slide 350ms |
| `signup` | `/signup` | SignupScreen | slide 350ms |
| `home` | `/home` | HomeScreen | fade 400ms |
| `explore` | `/explore` | ExploreScreen | slide 350ms |
| `productList` | `/products` | MensCategoryScreen | slide 350ms |
| `productDetail` | `/products/:id` | ProductDetailScreen | slide 350ms |
| `cart` | `/cart` | CartScreen | slide 350ms |
| `wishlist` | `/wishlist` | WishlistScreen | slide 350ms |
| `profile` | `/profile` | ProfileScreen | slide 350ms |
| `orders` | `/orders` | OrdersScreen | slide 350ms |
| `orderConfirmation` | `/order-confirmation` | OrderConfirmationScreen | fade 400ms |
| `notifications` | `/notifications` | NotificationsScreen | slide 350ms |
| `editProfile` | `/profile/edit` | **No screen exists** | ❌ |

**GoRouter redirect logic:**
- Not authenticated + not on auth route → redirect to `/login`
- Authenticated + on auth route → redirect to `/home`

---

## 7. Screen-by-Screen Code Logic

### 7.1 SplashScreen
- Animated logo entrance, auto-navigates to `/home` after delay
- GoRouter redirect handles auth check

### 7.2 LoginScreen
- Email + password fields with validation
- Calls `AuthProvider.login()` — any email/password works
- Shows loading spinner during auth
- Link to SignupScreen

### 7.3 SignupScreen
- First name, last name, email, password fields
- Calls `AuthProvider.signup()`
- Any values work (no real validation beyond empty checks)

### 7.4 HomeScreen
- Category chips (NEW, MEN, WOMEN, BEAUTY, KIDS) — filters product grid
- `_selectedCategory` defaults to 1 (MEN)
- Filter button → `// TODO` (does nothing)
- Hero banner "SHOP NOW" button → `() {}` (does nothing)
- Sub-category circles → no tap handler (tapping does nothing)
- Product card wishlist heart → toggles `product.wishlisted` (local only, resets on navigate)
- Product card cart button → `AppData.addToCart()` + SnackBar
- Product card tap → `context.push('/products/$globalIndex')` → ProductDetailScreen
- Back arrow in header → `Navigator.of(context).maybePop()` (goes nowhere on home, since home is root)
- Notifications button → `/notifications`
- Bottom nav: HOME(0), EXPLORE(1), FAVOURITE(2), CART(3), PROFILE(4)

### 7.5 ExploreScreen
- Search bar → TextField renders but search does nothing (no filtering logic)
- Filter button → `// TODO` (does nothing)
- Tabs (NEW, MEN, WOMEN, BEAUTY, KIDS) → filters `_filteredCats` shown in cards
- Category cards tap → `context.push(RouteNames.productList)` → MensCategoryScreen
- Curated Series cards → no tap handler (tapping does nothing)
- Menu (hamburger) icon in header → no tap handler (does nothing)
- Notifications → `/notifications`

### 7.6 ProductListScreen (`MensCategoryScreen`)
- Category chips filter product grid (same 5 categories)
- Filter button → `// TODO`
- Hero banner "SHOP NOW" → `() {}` (does nothing)
- Sub-category circles → no tap handler
- Product card tap → `context.push('/products/$globalIndex')` → ProductDetailScreen
- Product card wishlist → toggles locally
- Product card add-to-cart → `AppData.addToCart()` + SnackBar
- Back button → `context.pop()` or falls back to `/home`

### 7.7 ProductDetailScreen
- Receives `productId` (string index) from route
- Color swatches — toggles `_selectedColor` (visual only, does not affect CartItem)
- Size buttons — toggles `_selectedSize` (used in CartItem variant)
- Bag icon (header) → `context.go(RouteNames.cart)`
- Bag icon (bottom bar) → `_pushCartScreen()` (Navigator push)
- **"Add to Cart" button flow:**
  1. `AppData.addToCart(CartItem(name, size, price, imageUrl))`
  2. `_showToastThenNavigate()` — overlay toast slides down (~900ms total)
  3. After toast → `_pushCartScreen()` → iOS-style Navigator.push to CartScreen
- Back arrow → `context.pop()` or `/home`

### 7.8 CartScreen
- Reads from `AppData.cartItems()` (live reference)
- Qty stepper (+ / −) → mutates `item.qty` directly, calls `setState`
- Edit mode toggle → shows delete icon per row
- Delete → `AppData.cartItems().removeAt(i)` + `setState`
- Promo code "Apply" → no logic (TextField + button, nothing happens)
- Shipping: free if subtotal ≥ LKR 5,000, else LKR 350
- "Proceed to Checkout" → `context.go(RouteNames.orderConfirmation)`
- Back arrow → `Navigator.of(context).pop()` if pushed, else `context.go(home)`
- **No bottom nav** (intentional — accessed via push, not GoRouter tab)

### 7.9 WishlistScreen
- Static list from `AppData.wishlistItems()` — new list on each call
- Heart toggle → `item.wishlisted = !item.wishlisted` (local, resets on re-navigate)
- Cart button → `AppData.addToCart()` + SnackBar
- Product cards → **no tap to detail** (no navigation on card tap)
- "Continue Shopping" → `/home`
- Cart icon in header → `/cart`

### 7.10 ProfileScreen
- Hardcoded user name "Sarah", email "sarahvelour01@gmail.com"
- Not connected to `AuthProvider.user`
- Profile avatar edit button → no action (just visual)
- "My Orders" → `/orders` (stub screen)
- "My Details" → `() {}` (does nothing)
- "Shipping Address" → `() {}` (does nothing)
- "Payment Methods" → `() {}` (does nothing)
- "Notifications" → `() {}` (does nothing)
- "Language" → `() {}` (does nothing)
- "Privacy Policy" → `() {}` (does nothing)
- **"LOG OUT"** → `context.go(RouteNames.login)` ⚠️ Does NOT call `AuthProvider.logout()` — user stays authenticated in memory, GoRouter will immediately redirect back to `/home`

### 7.11 OrdersScreen
- **STUB** — just shows "Orders — Coming Soon" text
- No real UI, no data, no navigation

### 7.12 OrderConfirmationScreen
- Hardcoded order data (not from actual cart)
- Hardcoded user name "Sarah" (not from AuthProvider)
- Hardcoded order # `#VLR-20250413`
- Hardcoded delivery date "April 18-20, 2025"
- Hardcoded total "LKR 13,230" (ignores real cart)
- "Track My Order" → `/orders` (stub)
- "Continue Shopping" → `/home`
- Close (X) → `/home`

### 7.13 NotificationsScreen
- Renders static list from `AppData.notifications()`
- Notification items are not tappable (no action)

---

## 8. Navigation Flow Diagram

```
Splash
  │
  ▼
Login ──────────────────────────────────────────────────────────►
  │                                                              │
  ▼                                                              │
Home ◄─── (GoRouter redirect when authenticated) ───────────────┘
  │
  ├─► Explore ──► ProductList ──► ProductDetail ──► [Push] CartScreen
  │                                    │                   │
  │                                    └──► (go) Cart      └──► OrderConfirmation ──► Orders (stub)
  │
  ├─► Wishlist
  ├─► Cart (go_router route)
  ├─► Profile ──► Orders (stub)
  └─► Notifications
```

---

## 9. UI Design System

### Fonts
| Font | Usage |
|---|---|
| Newsreader | Headings, product names, logo, prices, serif elements |
| Be Vietnam Pro | Body text, labels, buttons, navigation |

### Primary Color Palette (used across screens — NOT from a single source)

| Token | Hex | Used In |
|---|---|---|
| Primary (terracotta) | `#914722` | Cart, Wishlist, Profile, Confirmation |
| Primary (lighter) | `#C06C44` | Home, Explore tabs |
| Primary container | `#AF5F38` | Gradients |
| Tertiary | `#745726` | Cart stepper, totals |
| Surface | `#FAF9F5` | Most screen backgrounds |
| On Surface | `#1B1C1A` | Body text |
| On Surface Variant | `#54433C` | Muted text |
| Outline Variant | `#DAC1B8` | Borders |

> ⚠️ **Consistency Problem**: Each screen defines its own `static const Color` values locally. The same color appears as `#914722`, `#8C4B27`, `#8B6914`, and `#C06C44` in different files. `app_colors.dart` exists but is only used in `home_screen.dart`.

### Bottom Navigation Bar
- Duplicated in: HomeScreen, ExploreScreen, WishlistScreen, ProfileScreen, CartScreen (old), ProductListScreen
- Each screen has its own implementation (no shared widget)
- CartScreen (new) has **no bottom nav** — accessed via Navigator push
- Icon sizes inconsistent: 24px vs 28px across screens

---

## 10. Known Bugs & Broken Buttons

### 🔴 Critical (Broken Functionality)

| # | Location | Issue |
|---|---|---|
| 1 | ProfileScreen → LOG OUT | Does not call `AuthProvider.logout()`. Navigates to `/login` but GoRouter immediately redirects back to `/home` since auth state is still `authenticated`. **User cannot log out.** |
| 2 | OrderConfirmationScreen | Shows hardcoded items (Cashmere Sweater, Leather Sneakers) instead of actual cart contents. Total is hardcoded as "LKR 13,230". |
| 3 | OrderConfirmationScreen | Greeting says "Thank you, Sarah!" regardless of who logged in. |
| 4 | OrdersScreen | Shows only "Orders — Coming Soon" — completely unbuilt. |
| 5 | `AppData.products()` | Returns a new list on every call. Wishlist toggle (`product.wishlisted`) resets when navigating away and back because a fresh list is returned. |
| 6 | `AppData.wishlistItems()` | Same issue — returns new list. Cart add from wishlist works, but heart toggle is non-persistent. |

### 🟠 Non-Functional Buttons / TODO Items

| # | Location | Element | Current State |
|---|---|---|---|
| 7 | HomeScreen | Filter (tune) button | `// TODO` — does nothing |
| 8 | HomeScreen | Hero banner "SHOP NOW" | `() {}` — does nothing |
| 9 | HomeScreen | Sub-category circles (Shirts, Jeans…) | No `onTap` — does nothing |
| 10 | HomeScreen | Back arrow (header) | `Navigator.maybePop()` — does nothing on home (it's the root) |
| 11 | ExploreScreen | Hamburger menu icon | No `onTap` — does nothing |
| 12 | ExploreScreen | Search bar | Renders TextField but no search/filter logic |
| 13 | ExploreScreen | Filter button | `// TODO` — does nothing |
| 14 | ExploreScreen | Curated Series cards | No `onTap` — does nothing |
| 15 | ProductListScreen | Filter button | `// TODO` — does nothing |
| 16 | ProductListScreen | Hero banner "SHOP NOW" | `() {}` — does nothing |
| 17 | ProductListScreen | Sub-category circles | No `onTap` — does nothing |
| 18 | WishlistScreen | Product card tap | No navigation to ProductDetailScreen |
| 19 | CartScreen | Promo code "Apply" | No logic, does nothing |
| 20 | ProfileScreen | Profile avatar edit button | No `onTap` — just visual |
| 21 | ProfileScreen → My Details | Row tap | `() {}` — does nothing |
| 22 | ProfileScreen → Shipping Address | Row tap | `() {}` — does nothing |
| 23 | ProfileScreen → Payment Methods | Row tap | `() {}` — does nothing |
| 24 | ProfileScreen → Notifications | Row tap | `() {}` — does nothing |
| 25 | ProfileScreen → Language | Row tap | `() {}` — does nothing |
| 26 | ProfileScreen → Privacy Policy | Row tap | `() {}` — does nothing |
| 27 | OrderConfirmationScreen → Track My Order | Goes to Orders stub | Stub shows "Coming Soon" |

### 🟡 Architecture / Code Quality Issues

| # | Issue | Location |
|---|---|---|
| 28 | Bottom nav is duplicated 5+ times | Each screen has its own copy — should be a shared widget |
| 29 | Color tokens are not centralized | Each screen redefines the same colors locally |
| 30 | `app_theme.dart` exists but is NOT wired into `MaterialApp` | `lib/core/theme/app_theme.dart` |
| 31 | `editProfile` route defined but no screen exists | `route_names.dart` line 15, no GoRoute for it |
| 32 | `screen/` folder exists but is unknown/unused | `lib/screen/` |
| 33 | `config/` folder is empty | `lib/config/` |
| 34 | `MensCategoryScreen` class name is misleading | File: product_list_screen.dart, class: MensCategoryScreen |
| 35 | Product color selection on detail screen doesn't carry to cart | `_selectedColor` is visual only |
| 36 | `category` query param in productList route is captured but unused | `app_router.dart` line 78 |
| 37 | `withOpacity()` used everywhere — deprecated in Flutter 3.x | Should use `.withValues(alpha: x)` |
| 38 | Cart items default quantity is 1 but pre-seeded cart items have qty=1 too | Minor, consistent |
| 39 | Notifications screen unused_local_variable lint warning | `notifications_screen.dart` line 142 |
| 40 | `test_layout.dart` at project root has unused imports | Should be deleted |

---

## 11. Navigation Inconsistencies

| Screen | Back Button Behavior | Expected |
|---|---|---|
| HomeScreen | `Navigator.maybePop()` — does nothing | Should be intentionally no back (it's root) |
| CartScreen | `Navigator.pop()` if pushed, else `go(home)` | ✅ Correct |
| WishlistScreen | `context.go(home)` | ✅ OK |
| ProfileScreen | `context.go(home)` | ✅ OK |
| ProductDetailScreen | `context.pop()` or `go(home)` | ✅ OK |
| OrderConfirmationScreen | X icon → `go(home)` | ✅ OK |
| CartScreen (via GoRouter `/cart`) | `go(home)` | May lose back stack context |

**Mixing `go()` and `push()`:**
- Most screens use `context.go()` which **replaces** the entire route stack
- ProductDetail uses `context.push()` from Home/ProductList grids — correct
- CartScreen now uses `Navigator.push` (custom) from ProductDetail — correct for animation
- But if user navigates to `/cart` via bottom nav (`context.go`), the back button goes home, not back to ProductDetail

---

## 12. State Management Summary

| State | Where Managed | Persistence |
|---|---|---|
| Auth (login/logout) | `AuthProvider` (ChangeNotifier) | In-memory only |
| Cart items | `AppData._cartItemsList` (static list) | In-memory, survives navigation |
| Wishlist items | `AppData.wishlistItems()` (new list each call) | ❌ Resets on re-navigate |
| Product wishlisted flag | `Product.wishlisted` field | ❌ Resets (new list each call) |
| Selected category chip | Local `setState` | ❌ Resets on navigate away |
| Selected size/color (PDP) | Local `setState` | ❌ Resets on navigate away |
| Cart item quantity | `CartItem.qty` field | ✅ Persists (shared reference) |
| Nav bar index | Local `setState` | ❌ Resets on navigate away |

---

## 13. What Has Been Built (Working)

- ✅ Splash → Login → Signup → Home flow (fake auth)
- ✅ Home: category filter, product grid, wishlist toggle (local), add to cart
- ✅ Explore: category tabs filter cards, image loading with error/loading states
- ✅ ProductList: category filter, product grid, add to cart, navigate to detail
- ✅ ProductDetail: image, name, price, description, color/size selection, add-to-cart toast + iOS push to Cart
- ✅ CartScreen: items with qty stepper, shipping calc, order summary, checkout button
- ✅ Wishlist: display items, toggle heart, add to cart
- ✅ Profile: display (hardcoded), menu rows, log out (broken but navigates)
- ✅ OrderConfirmation: UI complete (data hardcoded)
- ✅ Notifications: static list display
- ✅ GoRouter with redirect guard
- ✅ iOS-style push transition + toast (ProductDetail → Cart)

---

## 14. What Needs To Be Built (Future Work)

### 🔴 Priority 1 — Fix Broken Core

1. **Fix LOG OUT** — call `AuthProvider.logout()` before navigating
2. **Fix `AppData.products()` / `wishlistItems()`** — make them return the same mutable list (like `cartItems()`)
3. **Fix OrderConfirmationScreen** — use actual cart items and logged-in user name
4. **Build OrdersScreen** — list of past orders with status

### 🟠 Priority 2 — Complete Features

5. **Search** — wire the search bar in ExploreScreen to filter products
6. **Product filter/sort** — implement filter sheet (size, color, price range)
7. **Sub-category navigation** — tapping circles should navigate to filtered product list
8. **Wishlist → ProductDetail** — tapping wishlist card should open product detail
9. **Hero banner "SHOP NOW"** — link to relevant product list
10. **Curated Series cards** — navigate to filtered product list
11. **Real color selection** — selected color on PDP should be included in CartItem

### 🟡 Priority 3 — Profile & Account

12. **My Details screen** — edit name, email, phone
13. **Shipping Address screen** — add/edit addresses
14. **Payment Methods screen** — card management UI
15. **Settings screens** — notification prefs, language picker
16. **Connect profile to AuthProvider.user** — show real logged-in name/email

### 🟢 Priority 4 — Architecture & Polish

17. **Shared BottomNavBar widget** — extract one reusable widget
18. **Centralize color tokens** — all screens use `AppColors` from `app_colors.dart`
19. **Wire `app_theme.dart`** into `MaterialApp` theme
20. **Persistent state** — use `SharedPreferences` or Hive for cart, wishlist, auth session
21. **Real backend** — Firebase Auth + Firestore or REST API
22. **Image asset management** — local assets for offline fallback
23. **Checkout flow** — address selection → payment → confirmation
24. **Delete `test_layout.dart`** from project root
25. **Replace `withOpacity()`** with `.withValues(alpha:)` everywhere

---

## 15. Quick Reference — Adding New Screens

**Step 1** — Add route name in `lib/routes/route_names.dart`:
```dart
static const String myNewScreen = '/my-new-screen';
```

**Step 2** — Add GoRoute in `lib/routes/app_router.dart`:
```dart
GoRoute(
  path: RouteNames.myNewScreen,
  pageBuilder: (context, state) => _slideTransition(state, const MyNewScreen()),
),
```

**Step 3** — Create screen file in appropriate `lib/features/` subfolder.

**Step 4** — Add import at top of `app_router.dart`.

---

## 16. Quick Reference — Adding Products

All products are in `AppData.products()` in `lib/data/app_data.dart`:
```dart
Product(
  name: 'Product Name',
  category: 'MEN',        // or WOMEN, KIDS, BEAUTY
  description: '...',
  price: 'LKR 3,500.00',
  imageUrl: 'https://...',
)
```

The product index in this list = the `productId` passed to ProductDetailScreen.

---

## 17. Quick Reference — Cart System

```dart
// Add item to cart from anywhere:
AppData.addToCart(CartItem(
  'Product Name',
  'Variant / Size',
  'LKR 3,500.00',
  'https://image-url',
));

// Read cart items:
final items = AppData.cartItems(); // returns shared mutable list

// CartItem fields:
item.name
item.variant
item.price    // String like "LKR 3,500.00"
item.imageUrl
item.qty      // int, mutable
```

---

*End of Blueprint*
