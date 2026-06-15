import 'package:flutter/material.dart';
import 'models.dart';
export 'models.dart';

/// Centralized data layer for the entire application.
class AppData {
  static const List<Category> categories = [
    Category('All'),
    Category('Shirts'),
    Category('T-Shirts'),
    Category('Jeans'),
    Category('Outerwear'),
    Category('Summer'),
    Category('Tops'),
    Category('Sarees'),
    Category('Skirts'),
    Category('Kids'),
  ];

  static const List<SubCategory> subCategories = [
    SubCategory('Shirts', 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400'),
    SubCategory('T-Shirts', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400'),
    SubCategory('Jeans', 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400'),
    SubCategory('Tops', 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=400'),
  ];

  // Helper to generate the standard 5 color variants for a product
  static List<ColorVariant> _genColors(String mainUrl) {
    return [
      ColorVariant(name: 'Black', color: const Color(0xFF222222), imageUrl: mainUrl),
      const ColorVariant(name: 'White', color: Color(0xFFF5F5F5), imageUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=400'),
      const ColorVariant(name: 'Navy', color: Color(0xFF1A2A5A), imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400'),
      const ColorVariant(name: 'Red', color: Color(0xFFC0392B), imageUrl: 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=400'),
      const ColorVariant(name: 'Beige', color: Color(0xFFE8D5B0), imageUrl: 'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=400'),
    ];
  }

  static final List<Product> _productsList = [
    // ── SHIRTS ───────────────────────────────────────────────────────────────
    Product(
      name: 'White Formal Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 9,800',
      imageUrl: 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400'),
    ),
    Product(
      name: 'Blue Oxford Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 11,760',
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400'),
    ),
    Product(
      name: 'Black Slim Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 10,640',
      imageUrl: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=400'),
    ),
    Product(
      name: 'Striped Cotton Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 9,240',
      imageUrl: 'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=400'),
    ),
    Product(
      name: 'Navy Linen Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 12,600',
      imageUrl: 'https://images.unsplash.com/photo-1620012253295-c15cc3e65df4?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1620012253295-c15cc3e65df4?w=400'),
    ),
    Product(
      name: 'Grey Casual Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 8,120',
      imageUrl: 'https://images.unsplash.com/photo-1589310243389-96a5483213a8?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1589310243389-96a5483213a8?w=400'),
    ),
    Product(
      name: 'White Dress Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 15,400',
      imageUrl: 'https://images.unsplash.com/photo-1563630423918-b58f07336ac5?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1563630423918-b58f07336ac5?w=400'),
    ),
    Product(
      name: 'Checked Flannel Shirt',
      category: 'Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 10,360',
      imageUrl: 'https://images.unsplash.com/photo-1542060748-10c28b62716f?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1542060748-10c28b62716f?w=400'),
    ),

    // ── T-SHIRTS ─────────────────────────────────────────────────────────────
    Product(
      name: 'Black Round Neck Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 7,000',
      imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400'),
    ),
    Product(
      name: 'White Basic Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 5,600',
      imageUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=400'),
    ),
    Product(
      name: 'Navy Polo Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 8,400',
      imageUrl: 'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=400'),
    ),
    Product(
      name: 'Grey Graphic Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 7,560',
      imageUrl: 'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400'),
    ),
    Product(
      name: 'Red Oversized Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 8,960',
      imageUrl: 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1562157873-818bc0726f68?w=400'),
    ),
    Product(
      name: 'Green Crew Neck Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 6,720',
      imageUrl: 'https://images.unsplash.com/photo-1529374255404-311a2a4f1fd9?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1529374255404-311a2a4f1fd9?w=400'),
    ),
    Product(
      name: 'Yellow Printed Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 6,160',
      imageUrl: 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=400'),
    ),
    Product(
      name: 'Brown Vintage Tee',
      category: 'T-Shirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 7,840',
      imageUrl: 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=400'),
    ),

    // ── JEANS ────────────────────────────────────────────────────────────────
    Product(
      name: 'Slim Fit Blue Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 13,720',
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1542272604-787c3835535d?w=400'),
    ),
    Product(
      name: 'Black Skinny Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 14,560',
      imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400'),
    ),
    Product(
      name: 'Light Wash Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 12,880',
      imageUrl: 'https://images.unsplash.com/photo-1475178626620-a4d074967452?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1475178626620-a4d074967452?w=400'),
    ),
    Product(
      name: 'Ripped Denim Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 16,240',
      imageUrl: 'https://images.unsplash.com/photo-1555689502-c4b22d76c56f?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1555689502-c4b22d76c56f?w=400'),
    ),
    Product(
      name: 'Dark Indigo Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 15,120',
      imageUrl: 'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1604176354204-9268737828e4?w=400'),
    ),
    Product(
      name: 'Grey Straight Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 13,160',
      imageUrl: 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=400'),
    ),
    Product(
      name: 'Cropped White Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 12,320',
      imageUrl: 'https://images.unsplash.com/photo-1600717535275-0b18ede2f7fc?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1600717535275-0b18ede2f7fc?w=400'),
    ),
    Product(
      name: 'Bootcut Brown Jeans',
      category: 'Jeans',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 14,280',
      imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400'),
    ),

    // ── TOPS ─────────────────────────────────────────────────────────────────
    Product(
      name: 'Floral Chiffon Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 7,840',
      imageUrl: 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=400'),
    ),
    Product(
      name: 'White Crop Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 6,160',
      imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4b4168?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1594938298603-c8148c4b4168?w=400'),
    ),
    Product(
      name: 'Black Off-Shoulder Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 9,520',
      imageUrl: 'https://images.unsplash.com/photo-1564257631407-4deb1f99d992?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1564257631407-4deb1f99d992?w=400'),
    ),
    Product(
      name: 'Striped Knit Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 8,400',
      imageUrl: 'https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=400'),
    ),
    Product(
      name: 'Pink Ruffle Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 7,280',
      imageUrl: 'https://images.unsplash.com/photo-1566206091558-7f218b696731?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1566206091558-7f218b696731?w=400'),
    ),
    Product(
      name: 'Beige Linen Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 8,960',
      imageUrl: 'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=400'),
    ),
    Product(
      name: 'Red Halter Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 8,120',
      imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400'),
    ),
    Product(
      name: 'Green Wrap Top',
      category: 'Tops',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 7,560',
      imageUrl: 'https://images.unsplash.com/photo-1583744946564-b52ac1c389c8?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1583744946564-b52ac1c389c8?w=400'),
    ),

    // ── SAREES ───────────────────────────────────────────────────────────────
    Product(
      name: 'Red Silk Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 24,920',
      imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400'),
    ),
    Product(
      name: 'Blue Banarasi Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 33,600',
      imageUrl: 'https://images.unsplash.com/photo-1617627143233-a775eb1ce7b6?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1617627143233-a775eb1ce7b6?w=400'),
    ),
    Product(
      name: 'Green Kanjivaram Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 37,800',
      imageUrl: 'https://images.unsplash.com/photo-1614886137799-03c78b4e45cd?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1614886137799-03c78b4e45cd?w=400'),
    ),
    Product(
      name: 'Yellow Georgette Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 21,000',
      imageUrl: 'https://images.unsplash.com/photo-1609357605129-4a2ff1b5af27?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1609357605129-4a2ff1b5af27?w=400'),
    ),
    Product(
      name: 'Pink Chiffon Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 19,040',
      imageUrl: 'https://images.unsplash.com/photo-1622495966027-e0173192c728?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1622495966027-e0173192c728?w=400'),
    ),
    Product(
      name: 'Purple Embroidered Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 40,600',
      imageUrl: 'https://images.unsplash.com/photo-1583391733956-6c78276477e1?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1583391733956-6c78276477e1?w=400'),
    ),
    Product(
      name: 'Orange Printed Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 22,960',
      imageUrl: 'https://images.unsplash.com/photo-1602516563-5b2a5c42f9d0?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1602516563-5b2a5c42f9d0?w=400'),
    ),
    Product(
      name: 'White Cotton Saree',
      category: 'Sarees',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 16,520',
      imageUrl: 'https://images.unsplash.com/photo-1618898909019-010e4e234c55?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1618898909019-010e4e234c55?w=400'),
    ),

    // ── SKIRTS ───────────────────────────────────────────────────────────────
    Product(
      name: 'Pleated Mini Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 8,960',
      imageUrl: 'https://images.unsplash.com/photo-1583496661160-fb5974ca9f65?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1583496661160-fb5974ca9f65?w=400'),
    ),
    Product(
      name: 'Denim A-Line Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 10,640',
      imageUrl: 'https://images.unsplash.com/photo-1572804013427-4d7ca7268217?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1572804013427-4d7ca7268217?w=400'),
    ),
    Product(
      name: 'Floral Midi Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 11,760',
      imageUrl: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1561677843-39dee7a319ca?w=400'),
    ),
    Product(
      name: 'Black Wrap Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 9,800',
      imageUrl: 'https://images.unsplash.com/photo-1598554747436-c9293d6a588f?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1598554747436-c9293d6a588f?w=400'),
    ),
    Product(
      name: 'White Lace Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 13,440',
      imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400'),
    ),
    Product(
      name: 'Red Slit Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 12,320',
      imageUrl: 'https://images.unsplash.com/photo-1603006905003-be475563bc59?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1603006905003-be475563bc59?w=400'),
    ),
    Product(
      name: 'Brown Suede Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 15,400',
      imageUrl: 'https://images.unsplash.com/photo-1592301933927-35b597393c0a?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1592301933927-35b597393c0a?w=400'),
    ),
    Product(
      name: 'Pink Tulle Skirt',
      category: 'Skirts',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 10,920',
      imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400'),
    ),

    // ── KIDS ─────────────────────────────────────────────────────────────────
    Product(
      name: 'Boys Graphic Tee',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 5,040',
      imageUrl: 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400'),
    ),
    Product(
      name: 'Girls Floral Frock',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 6,160',
      imageUrl: 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=400'),
    ),
    Product(
      name: 'Boys Denim Shorts',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 5,600',
      imageUrl: 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=400'),
    ),
    Product(
      name: 'Girls Pink Top',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 5,320',
      imageUrl: 'https://images.unsplash.com/photo-1543087903-1ac2ec7aa8c5?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1543087903-1ac2ec7aa8c5?w=400'),
    ),
    Product(
      name: 'Boys Striped Shirt',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 6,720',
      imageUrl: 'https://images.unsplash.com/photo-1471286174890-9c112ffca5b4?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1471286174890-9c112ffca5b4?w=400'),
    ),
    Product(
      name: 'Girls Denim Skirt',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 5,880',
      imageUrl: 'https://images.unsplash.com/photo-1604488573878-b5f92595c5b3?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1604488573878-b5f92595c5b3?w=400'),
    ),
    Product(
      name: 'Boys Hoodie',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 9,800',
      imageUrl: 'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=400'),
    ),
    Product(
      name: 'Girls Party Dress',
      category: 'Kids',
      description: 'Premium quality fabric, modern fit. Perfect for everyday wear.',
      price: 'LKR 12,600',
      imageUrl: 'https://images.unsplash.com/photo-1476234251651-f353703a034d?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1476234251651-f353703a034d?w=400'),
    ),
    Product(
      name: 'Classic Trench Coat',
      category: 'Outerwear',
      description: 'Double-breasted trench coat with a belt. Premium cotton blend.',
      price: 'LKR 28,500',
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400'),
    ),
    Product(
      name: 'Suede Bomber Jacket',
      category: 'Outerwear',
      description: 'Soft suede jacket with ribbed cuffs and collar.',
      price: 'LKR 32,000',
      imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400'),
    ),
    Product(
      name: 'Linen Summer Dress',
      category: 'Summer',
      description: 'Lightweight linen dress with tie straps.',
      price: 'LKR 14,800',
      imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400'),
    ),
    Product(
      name: 'Floral Summer Romper',
      category: 'Summer',
      description: 'Comfortable cotton romper with a vibrant floral print.',
      price: 'LKR 11,500',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
      colorVariants: _genColors('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400'),
    ),

    // ── SKINCARE ─────────────────────────────────────────────────────────────
    Product(
      name: 'Hydrating Face Moisturizer',
      category: 'Skincare',
      description: 'Deep hydration formula for all skin types. Dermatologist tested.',
      price: 'LKR 3,920',
      imageUrl: 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Vitamin C Serum',
      category: 'Skincare',
      description: 'Brightening serum with 20% Vitamin C. Reduces dark spots.',
      price: 'LKR 5,600',
      imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'SPF 50 Sunscreen',
      category: 'Skincare',
      description: 'Lightweight sunscreen with broad spectrum UVA/UVB protection.',
      price: 'LKR 2,800',
      imageUrl: 'https://images.unsplash.com/photo-1526758097130-bab247274f58?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Retinol Night Cream',
      category: 'Skincare',
      description: 'Anti-aging night cream with retinol and hyaluronic acid.',
      price: 'LKR 6,720',
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Rose Water Toner',
      category: 'Skincare',
      description: 'Balancing toner with pure rose water. Refreshes and hydrates.',
      price: 'LKR 2,240',
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Gentle Foam Cleanser',
      category: 'Skincare',
      description: 'Soap-free cleanser that removes impurities without stripping moisture.',
      price: 'LKR 1,960',
      imageUrl: 'https://images.unsplash.com/photo-1631729371254-42c2892f0e6e?w=400',
      colorVariants: [],
    ),

    // ── MAKEUP ───────────────────────────────────────────────────────────────
    Product(
      name: 'Matte Lipstick — Ruby Red',
      category: 'Makeup',
      description: 'Long-wearing matte formula. Rich pigment, comfortable wear.',
      price: 'LKR 2,520',
      imageUrl: 'https://images.unsplash.com/photo-1586495777744-4e6232bf4868?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Full Coverage Foundation',
      category: 'Makeup',
      description: 'Buildable coverage with a natural finish. SPF 15.',
      price: 'LKR 4,480',
      imageUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Volumising Mascara',
      category: 'Makeup',
      description: 'Dramatic volume and length. Smudge-proof, 24-hour wear.',
      price: 'LKR 3,360',
      imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Highlighter Palette',
      category: 'Makeup',
      description: 'Four shades of luminous highlight for a radiant glow.',
      price: 'LKR 3,920',
      imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400',
      colorVariants: [],
    ),

    // ── FRAGRANCE ────────────────────────────────────────────────────────────
    Product(
      name: 'Floral Eau de Parfum',
      category: 'Fragrance',
      description: 'A bouquet of rose, jasmine and peony. Feminine and long-lasting.',
      price: 'LKR 14,000',
      imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Woody Oud Cologne',
      category: 'Fragrance',
      description: 'Bold oud and sandalwood accord with citrus top notes.',
      price: 'LKR 18,200',
      imageUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Fresh Citrus Mist',
      category: 'Fragrance',
      description: 'Light body mist with lemon, bergamot and green tea.',
      price: 'LKR 4,200',
      imageUrl: 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=400',
      colorVariants: [],
    ),

    // ── HAIR ─────────────────────────────────────────────────────────────────
    Product(
      name: 'Argan Oil Hair Serum',
      category: 'Hair',
      description: 'Frizz-control serum with pure Moroccan argan oil. Adds shine.',
      price: 'LKR 3,080',
      imageUrl: 'https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Repair & Restore Shampoo',
      category: 'Hair',
      description: 'Strengthening shampoo for damaged and colour-treated hair.',
      price: 'LKR 2,240',
      imageUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=400',
      colorVariants: [],
    ),
    Product(
      name: 'Deep Conditioning Mask',
      category: 'Hair',
      description: 'Intensive weekly treatment. Restores moisture and elasticity.',
      price: 'LKR 3,640',
      imageUrl: 'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab12?w=400',
      colorVariants: [],
    ),
  ];

  static List<Product> products() => _productsList;

  // ── Explore Data ─────────────────────────────────────────────────────────
  static const List<ExploreCategory> exploreCategories = [
    ExploreCategory(title: 'Denim & Jeans', subtitle: 'HERITAGE INDIGO', imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400'),
    ExploreCategory(title: 'Tailored Classics', subtitle: 'PRECISION CUTS', imageUrl: 'https://images.unsplash.com/photo-1594938298598-70f70f666752?w=400'),
    ExploreCategory(title: 'Outerwear', subtitle: 'THE SEASONAL COAT', imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400'),
    ExploreCategory(title: 'Little Velour', subtitle: 'MINIATURE LUXURY', imageUrl: 'https://images.unsplash.com/photo-1519238263530-99eaa1121d1e?w=400'),
  ];

  static const List<CuratedSeries> curatedSeries = [
    CuratedSeries(id: '01', title: 'The Terracotta Edit'),
    CuratedSeries(id: '02', title: 'Sculptural Jewelry'),
    CuratedSeries(id: '03', title: 'Winter Cashmere'),
    CuratedSeries(id: '04', title: 'Evening Wear'),
  ];

  // ── Shop Data (Wishlist, Cart, Orders) ───────────────────────────────────
  static final List<Product> _wishlistItemsList = [];

  static List<Product> wishlistItems() => _wishlistItemsList;

  static final List<CartItem> _cartItemsList = [];

  static List<CartItem> cartItems() => _cartItemsList;

  static void addToCart(CartItem item) {
    _cartItemsList.add(item);
  }

  static List<NotificationItem> notifications() => [
    const NotificationItem(icon: Icons.description_outlined, iconColor: Color(0xFF059669), bgColor: Color(0xFFECFDF5), title: 'Your order has been shipped!', subtitle: 'Your order #7732 is on its way to you.', time: '2 hours ago', isUnread: true, isFadedText: false),
  ];

  static const List<OrderSummaryItem> orderSummaryItems = [
    OrderSummaryItem(name: 'Cashmere Blend Sweater', variant: 'Beige • M', price: 'LKR 21,840', imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400'),
  ];
}
