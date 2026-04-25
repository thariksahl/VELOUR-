import 'package:flutter/material.dart';
import 'models.dart';
export 'models.dart';

/// Centralized data layer for the entire application.
class AppData {
  // ── Categories ───────────────────────────────────────────────────────────
  static const List<Category> categories = [
    Category('NEW'),
    Category('MEN'),
    Category('WOMEN'),
    Category('BEAUTY'),
    Category('KIDS'),
  ];

  // ── Sub-Categories ───────────────────────────────────────────────────────
  static const List<SubCategory> subCategories = [
    SubCategory('Shirts & t-shirts', 'https://lh3.googleusercontent.com/aida-public/AB6AXuA7AbG6W2UjYoTIu_NKf2snUzrilDvfou31ndhXovlmSbmUxKCjy37UEJRBIImOsMXbhFQlXn838BCIUGWlfRUe1dQXY_2d4eyKYaGMsDqtnWDuLVrLal_nlw5-k0CKlbnxcgI7SyVgw0AG3y5MXmHr1z28tFkqXFVWtHIZKybiWLYZ6x4yHeagO5Rh4ECnAi1z3THParxUnItCq3L0H2gL6pZcNma0GZLlYzG451CXuHm4fSWhoIRQ0zrh4BLNAesfr5U1_eToId0'),
    SubCategory('Tops', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBTqhdDGvYQ4bG_jf-V7l7iobpjyxChnR_RKqqi5wUmnJE5dFyaa0JwuYED7UilnMxTaainncZDd32zB1jCNOOBwn80AeENF929ds_tdqGSKCfgmFyrsOQqIpkM7zPUI3_g1IdfctvXu-6Xb8qk9C6U32cuNqzK2mXvfj0AM72bgHlw3kOw4qMpqOfxRN7JPY9m5CO4_7FhikAmGEx3Oq9YKNMSyE5Yop1sujjoj4gaToBd2_zRrp3g4YXg6yS_y_DalSHVU9xUdMM'),
    SubCategory('Jeans', 'https://lh3.googleusercontent.com/aida-public/AB6AXuAB-kDTl04AXVJBK65Wvfe3YW89cryb5kvbeIvn6ZhEy7pTq5RJHnkNASK5uo6TJT9TYSmvfKppdKrMV84s3Olwr3_NfTxR4Bn9bxlnUf7oFSgZHDDce_2RABc89QRYA7xByB6MiWrOK83GGHA-9QnUgS_kmM0gt_fKJV1bKyMCY8-_bP4XugJAH7TUo0vNZmyoMNr2yXzZ8luxfTYgYz4-sIXVcAEFn57eSHSKSgPjzTmwbIEvRWhQhVyRJLtj7PVr9YmIzRXcOAg'),
    SubCategory('Inner wear', 'https://lh3.googleusercontent.com/aida-public/AB6AXuCJFcT-W9sYOz-xEeQRgIepLyfCtXa_jQGYGKDZN8seUwozapKdLVpULG6xkR469_VNHaY-b_CnOqc5oAZtRwyqsP98PmN_TsfiJkqnUKoHiTsBJeB8-K6iwdPJlhCScic60OnsauKjQSuSx5F7aFwPZLfgSfRaS_ElInDJldL-Pl9aH7mpVFeVSAfLCj-q3Hk02K4df-qdrzpYG2lEzHydvTCjpH-wAqnN6ffdhNvzQIb3tcFe5lfebp4V-LZqSgF_nqrEDZoKUVc'),
    SubCategory('Sarees', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBGOQpn7UooNycDDUt29NNnpd9xlNp8zDC7exP8PgHHXzR5Ui88_FaQ0QPzNmaWGVueWU0Ml2YARE9Lyp6QlCvHwToWwOYSQPgXDzb81SF30oe5VZkNK_8B91hf48WY-Rt_B7gnfTHLvP0fhrLjkTO58oUz9sK84T2iUB9wzDljVUxmpCEEf1UfQuwhexZieOIQ2wThssBUbjrovuXf_xeUnALTTBNrRg-jpnt3Q68DvAuAgNrZNCFR9BvRU_beVE5gZGPijTImMZY'),
    SubCategory('SHIRTS', 'https://lh3.googleusercontent.com/aida-public/AB6AXuCiWaE7CicWf0lpYWri0WIhiJ3k5-jnQznlHQ8I5mOL7upMZ2hIQIH2IPYCSLzD_8M4J-n5agjKyoL-RKYkbXtFyFFeyf-2vF5H5gyK5nVnFhp4KtQqG-2WtlN5nfSAu9nASPVS92iu7RHHNeCHXyVilF0z1GxP2DYu7JL6flocEfuiS5KehNee-fKMsW_FpnNQOkAUeUznT-EOBp_-uuXGDF5gVAPy-uPf73eO8_PbD4MKjuvo19Uv5FUl0KBxaZ69-mVjHark21U'),
    SubCategory('T-SHIRT', 'https://lh3.googleusercontent.com/aida-public/AB6AXuDfmymYd3uHUW4Ovhp_uI_ycoTB9Nmp-c7dyWXv-cYsLcg-brU2I0qzXD3gf_g7UHclYd4GITjF-ML3Z4LfbzQ_u5SGglw0rzNq8qTAhnhXzxpkap_1N2CMOmVhupPXzw7kVCNGi4cIy6aITgeGVT_9ftdUyw1Uxxt9eNKvVdO1Yz9KqjPkjgSMijcWI1Rw9Dj0ro2oXtEl2XUxHAVmAZ78okWwYUxcXF49GE__2lpNR3udbRneVVM_7rFXtrBvoCOFKoOuuPj3YXI'),
    SubCategory('JEANS', 'https://lh3.googleusercontent.com/aida-public/AB6AXuB6YKPjTBr8edBozAVH9gYXinDgdD1n8sNULJvtJ9vCbbUJthgqJplDGkmgF8_RfWw6UFRk6zZEQhjJ2b8z06BKsteZu6aLePoEhwCuUNaiTR_DSmKp8vNjajcGDlXsHCF6Qr8fobA2itGePJOLZZytuoUQ_Lt2nG5tDPgPf5KalWM0a4-ZVHg-8aRIItKmGAp3U5mZPUe5exmrmjQ7pzYzorrpYkcKmGNMHmHBa73TH-_sn5yOMxdfWgGyMxq5CkrJyUyu62tyMOg'),
    SubCategory('INNER WEARS', 'https://lh3.googleusercontent.com/aida-public/AB6AXuAixXwLbPkRBQ1RIU7Rs97vLqvjv55tFttRSTqrLyhdt1kBJeMFLOem737m4hf9BUdcFfVzZJthkD0P-BTUpkN7CgUA5r1vR9A0ExqCjFxZtU9tioG7lCjnADEiUgaNLZ3ybuLw0C_8SJZt2BMGPjauujQ3AUNPeYRGqgDJT00ujecJ-t7HvsbRAAZuRpdzy-Af_762NfmiuRl88S7sMAcU7i01uiWRmp15jI7ZzpO2cwlKk42C9xyC5gNmp88s1hEGeQcusRjHZbw'),
  ];

  // ── Products ─────────────────────────────────────────────────────────────
  static final List<Product> _productsList = [
    Product(name: 'Essential Ribbed Crop Top', category: 'WOMEN', description: 'Modern silhouette with ultra-soft ribbed fabric for everyday comfort.', price: 'LKR 2,450.00', imageUrl: 'https://lh3.googleusercontent.com/aida/ADBb0ujGTLidAvMTCBfQLRksNXuw9j-EMCvDj_OtZtaTVYZrpRu7L2Hn4n66k-Cwy9mzRUGuXh_DEBYuPfxpPtsNM7eHEpabrrCMJJS2EZhhKevKSOc1lH7_2CiN08CLvX-BhA2j3aTkm3uujPjEXeZGnkS4fqrhptzXSUbAK6XB-ON3ccibnr9lsSlTAO0zqdWLQ3KfyENR1heibbkkpX20yDG2T0d1PBq7qYUOLQTp1nEsvpO2Aj9Q3L8FU3tAjaBd8Uj-Psz_haPcUQ'),
    Product(name: 'Tie-Dye "Happy" Hoodie', category: 'WOMEN', description: 'Vibrant cropped hoodie featuring a playful typographic detail.', price: 'LKR 4,890.00', imageUrl: 'https://lh3.googleusercontent.com/aida/ADBb0uj1rFrZml3gs_zgFAMy3bdFFM_wMZ9vxGJ1hV7nBJzOsgg6Kpd1VRXw82iK7XQWFtczNPttC6otoqcejxfaV0qhXTLLPYnj4kwQYqMVAgGpbRHBFSeAPQjwcPfDWi_QyCjLHjnhPnogxn1tMqyjX32CPeDXjrI7vyZxVkySadcruYWW_ETnpzaATqz4iaKLY6gVRggDwKJaycJ-Co43PBs1ogIEh8z0RtzwxmZQ9I8d8T8pQKM1p0sZSFLYrSu9I5ufrIWIS-TnMQ'),
    Product(name: 'Monochrome Patterned Blouse', category: 'WOMEN', description: 'Elegant geometric print shirt for a sophisticated professional look.', price: 'LKR 5,390.00', imageUrl: 'https://lh3.googleusercontent.com/aida/ADBb0ugBczwjG_MjsjCYPai63IaW9T6hRiac0HQOx06A7LLzLRoKwW_-BnBbPqmZ7LtBA0fxiB4OHQUdlaLWMz-edyENsJsknaokdQIkrmsF1c0BoHJjoO5t39f_O3q38G0wM2GBXIW2zXJ0DsXD_Vy21CoB3noj2LkHF5bM1NCd86t4Zy270qrDOfZsY9xjiml450U8QgCX4Oi_o1vYtzxsrR6HQxONe2gKkikVmF8gxPrB2rpRbx-9x4Y-zhXuDTlDEaBnwVIC_cze'),
    Product(name: 'Classic Light Blue Button-Up', category: 'MEN', description: 'Tailored cotton blend shirt in a timeless pastel blue shade.', price: 'LKR 3,840.00', imageUrl: 'https://lh3.googleusercontent.com/aida/ADBb0ujBGpreqlTv40Fe3hnF-eECHLQbGHfVAcG29PIWRlP6y1z3FA6Q_LxBhF4ilma8M2fU4syl-v1K3gliNqjdHOI92DgxcUdh0lpjmvSETm0hkQl14B1k-vflPkKQtWgT4yHZrx-yyIhmrW_N7MnBwvC4dnHpy85yC6J4gYFRAdVT73Ip1uZ8Zfwtw4NSSIf3GvFOvakpV3FmRvjGFJb8Z5T6vNJAmV-5OirvGuIkstJz_S9mjY7nPva5I-uF0MnDHNdIYyEQKBVXaQ'),
    Product(name: 'Everyday Chinos', category: 'MEN', description: 'Comfortable stretch chinos for an effortless look.', price: 'LKR 4,100.00', imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?q=80&w=800&auto=format&fit=crop'),
    Product(name: 'Casual Henley Shirt', category: 'MEN', description: 'Soft cotton henley with a three-button placket.', price: 'LKR 2,900.00', imageUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?q=80&w=800&auto=format&fit=crop'),
    Product(name: 'CASUAL SHIRT (GREEN)', category: 'MEN', price: 'LKR 5890.00', imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBemrxXDrZs69OwV-KX-NFoObNg1vCMQ6gRP309pEud_3BBeyRCKPWtI0tAafBa7mXkLjC13B7R2_EZuFT-amTsMLIs8Z-M6VEJUHrLJoXGxkv1YGcIi9vEnlwlJ-0rqzqyYA24NRdCS6NT6gqxVxYcchfyKeE_Xhk7zhAB19NLi2GN5RpoLPka7wg-ni_MD3zuXOh1c0iuiFk0sKVmg5S0x0ObvUCQ550hLvnVbpD4IHd82O-cj4WaIIlp1TGFillRdzlg5s8mOtI'),
    Product(name: 'WIDE-LEG JEANS (BLUE)', category: 'MEN', price: 'LKR 7250.00', imageUrl: 'https://lh3.googleusercontent.com/aida/ADBb0uiWaKgas07cnYTWqqJeTwJknwHpl8BEO91vZi3aUDkbL5u3dR6idk_t-R3JVcYzhwtCk9WeT0VOphD0KKihBH9lgB8AgkSjTWcRssm_5RTAtS-emNr42D8aVpFUyhb3qGgbcZdU5Lbls79YNOgWPrIuuNd1PPjj1pLOhJx8fmWEjwMkkycV7yQkxs_7VQn-YfyzrCRyVkRbJgPri8JxnDR1t3Dk5kaCMCtYkrnKll7dRBF6KM-bnl-R6craizwd9W_0Tc1Ffwoh4g'),
    Product(name: 'DRESS SHIRT (WHITE)', category: 'MEN', price: 'LKR 4990.00', imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDr6ebLnPshE5jXzcevjfSyN_m6aZRjcFVMs1NaY-NhRHFY00JZJJWR9KC9EpRHqyQITuF5j_AZxubm9bw29IEntY47xIWR7MzN-LSJin2_E7z3G6L6H0Q9nQRoUf2Wv6JWzLIaJ9Ulx3ZRTiUFaBrNrv12fTMIT9_xg7wGUEc2pbPZaWve2KSv4YxuqHG77opENWih3A_7p0PT1uHjhHSpd3kbz8rxw5vC4JvHzTXSXXGTHZRsMDLl1lcsId_FzZbMrpeFxbWM34Y'),
    Product(name: 'BASIC TEE (BLACK)', category: 'MEN', price: 'LKR 2850.00', imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDUIkIVfGDlgJDNjoW4S70cAA0p4qyMJ50Wt5KYZNjshe_9Vf0wZTA5X8Xf57acIXrcympQRU1psFR8NfpDg77xIDza-FZsXeUKW54FEQ4fsyBJkXlUdnsLn09ylQ6BHIg6z55j_QVmd5Az6dBujzHhUHRipXKwiyhRZQ6iYjYG03vPXyq8_Pl7BbNQ_yWda3YCpbiyaqwX-5y5qoSLYzHws3Wth9Wbj4eXy858_PL6h0MCByzE-m69R21In_dp7rnmn6OjBpionK0'),
    Product(name: 'ELEGANT DRESS (RED)', category: 'WOMEN', price: 'LKR 6500.00', imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?q=80&w=800&auto=format&fit=crop'),
    Product(name: 'SUMMER SKIRT (YELLOW)', category: 'WOMEN', price: 'LKR 3200.00', imageUrl: 'https://images.unsplash.com/photo-1583496661160-c588c443c982?q=80&w=800&auto=format&fit=crop'),
  ];

  static List<Product> products() => _productsList;



  // ── Explore Data ─────────────────────────────────────────────────────────
  static const List<ExploreCategory> exploreCategories = [
    ExploreCategory(title: 'Denim & Jeans', subtitle: 'HERITAGE INDIGO', imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=800&auto=format&fit=crop'),
    ExploreCategory(title: 'Tailored Classics', subtitle: 'PRECISION CUTS', imageUrl: 'https://images.unsplash.com/photo-1594938298598-70f70f666752?q=80&w=800&auto=format&fit=crop'),
    ExploreCategory(title: 'Outerwear', subtitle: 'THE SEASONAL COAT', imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?q=80&w=800&auto=format&fit=crop'),
    ExploreCategory(title: 'Little Velour', subtitle: 'MINIATURE LUXURY', imageUrl: 'https://images.unsplash.com/photo-1519238263530-99eaa1121d1e?q=80&w=800&auto=format&fit=crop'),
  ];

  static const List<CuratedSeries> curatedSeries = [
    CuratedSeries(id: '01', title: 'The Terracotta Edit'),
    CuratedSeries(id: '02', title: 'Sculptural Jewelry'),
    CuratedSeries(id: '03', title: 'Winter Cashmere'),
    CuratedSeries(id: '04', title: 'Evening Wear'),
  ];

  // ── Shop Data (Wishlist, Cart, Orders) ───────────────────────────────────
  static final List<Product> _wishlistItemsList = [
    _productsList[0],
    _productsList[1],
  ];

  static List<Product> wishlistItems() => _wishlistItemsList;

  static final List<CartItem> _cartItemsList = [
    CartItem('Relaxed Wide-Leg Jeans', 'Washed Blue', 'LKR 5,990.00', 'https://lh3.googleusercontent.com/aida/ADBb0uhn_jiFQoKWt--MifNFU_xIytSD_ieDOpy0ufhzzlYw5gwZH6jqO4C8SES3Gkt8kmYitpFzGoNJ6a6nY7jOnoYnzSs6SjQWJ0M5-Py8kBYkjd2CymeuGC-BUPcRMYWUARNal6-_LBOhkPHUQHdEPE7W0_cVltYoYYYR3mqPRkbHF_Ifty6ahuvC08m_jikOvBGXusV0VmWzgNWWHizu8CIk3G5OpMZHVX_Qs6W--vQvOpZ0drRBOdjih7PPByklWvTQVB2BZhIUgg'),
    CartItem('Essential Cotton Shirt', 'Pastel Blue', 'LKR 4,500.00', 'https://lh3.googleusercontent.com/aida/ADBb0ujsZzlon7zpU9FeqTwHAJmVFI4Lc1RncOZHIRStIjxzDd8q1IJ7eZl86-XENl_4mkSL2YkoPmnlFVtw1LO9EAAR5HUtCv6HV7K5OADs3n4RMG963zwyeBbD8E5jfDkvzsCJyjlS6BTgQajsF5Cwx2ZBmV59PHAQJPgbhbHzxWIhe0yvP6YG47CxOJXwkinV6nsxyI0KYmOjZBVeJoogpoLwC7ta7vYlE56KTN-yRjk71GyHOQO5jr_KinvICoPxCy6gvDRcgTUjDQ'),
  ];

  static List<CartItem> cartItems() => _cartItemsList;

  static void addToCart(CartItem item) {
    _cartItemsList.add(item);
  }

  static List<NotificationItem> notifications() => [
    const NotificationItem(icon: Icons.description_outlined, iconColor: Color(0xFF059669), bgColor: Color(0xFFECFDF5), title: 'Your order has been shipped!', subtitle: 'Your order #7732 is on its way to you.', time: '2 hours ago', isUnread: true, isFadedText: false),
    NotificationItem(icon: Icons.sell_outlined, iconColor: Colors.amber[600]!, bgColor: Colors.amber[50]!, title: 'Flash Sale! 40% Off Dresses', subtitle: "Don't miss out on our biggest sale of the season.", time: '2 hours ago', isUnread: true, isFadedText: false),
    NotificationItem(icon: Icons.star, iconColor: Colors.blue[600]!, bgColor: Colors.blue[50]!, title: 'New Arrivals Just Dropped', subtitle: 'Check out our latest collection of sustainable fabrics.', time: 'Yesterday', isUnread: false, isFadedText: true),
    const NotificationItem(icon: Icons.local_shipping_outlined, iconColor: Color(0xFF059669), bgColor: Color(0xFFECFDF5), title: 'Your order has been shipped!', subtitle: 'Order #6921 is being delivered today.', time: '2 days ago', isUnread: false, isFadedText: true),
    NotificationItem(icon: Icons.trending_down, iconColor: Colors.amber[600]!, bgColor: Colors.amber[50]!, title: 'Price Drop Alert!', subtitle: 'Items in your cart are now at a lower price.', time: '3 days ago', isUnread: false, isFadedText: true),
  ];

  static const List<OrderSummaryItem> orderSummaryItems = [
    OrderSummaryItem(name: 'Cashmere Blend Sweater', variant: 'Beige • M', price: 'LKR 7,885', imageUrl: 'https://lh3.googleusercontent.com/aida/ADBb0uj81_RL4tEc_W36ziECyvFjbyr4lB7NyQzMdv8qeZbs3VWMsx7qOYvVz5D6QuNz7bVAc4pYzSckU3lCDbFa-VXr9CMPfRyT_yp1Oy0scmqAUS9OvbMYQpK-JKo7_AR8e7OxSXgpg_pQb43kpIHKlYIK1Ng6LHKPOG0lrotXU1vm8k8AJFqTS3nch75RtrBVCyijvzNDbL77bOosmRTmU_HWdzRUA-vZ_ZngqBVhwwMZVOkizJIHjX3cdHrfCSak7a7Qpnq7GmfcUg'),
    OrderSummaryItem(name: 'Artisan Leather Sneakers', variant: 'White • 43', price: 'LKR 5,345', imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDBsiC8RU1Hh89IpZzUrDZBeb4rc1aw5XQz5jHbHhP7bpxXhX-JXYD9t46AeDuequvWOP87bUiDILZhFpH_siLTn7rZyrga-IihpKruICOIBRI0aYuCKKkagUMEUHswbj_4Ge53QNHK6lQg2AID0-Okaj5mHyImd_eC-21HYTkA_k-rJXiDiUjl2vbc7KnLuCt6pqSv2Bx6LIYCcDvxU738Rgf3Fh9h8YKD_pr95Ydmri5uzLegs0DWu6XMenHvETBieqCx50NOYbg'),
  ];
}
