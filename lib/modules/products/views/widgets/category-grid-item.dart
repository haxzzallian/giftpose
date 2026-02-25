import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/products/data-model/product-category.model.dart';
import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/text-styles.dart';

class CategoryGridItem extends StatelessWidget {
  final ProductCategory category;
  final VoidCallback onTap;

  const CategoryGridItem({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = categoryIcon(category.slug);
    final color = categoryColor(category.slug);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                category.name,
                style: captionStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: brandTextPrimary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Map category slugs to icons
IconData categoryIcon(String slug) {
  switch (slug) {
    case 'beauty':
    case 'skin-care':
      return Icons.face_retouching_natural;
    case 'fragrances':
      return Icons.spa_outlined;
    case 'furniture':
    case 'home-decoration':
      return Icons.chair_outlined;
    case 'groceries':
      return Icons.local_grocery_store_outlined;
    case 'laptops':
    case 'tablets':
    case 'smartphones':
    case 'mobile-accessories':
      return Icons.devices_outlined;
    case 'mens-shirts':
    case 'mens-shoes':
    case 'tops':
    case 'womens-dresses':
    case 'womens-bags':
    case 'womens-shoes':
      return Icons.checkroom_outlined;
    case 'mens-watches':
    case 'womens-watches':
    case 'womens-jewellery':
    case 'sunglasses':
      return Icons.watch_outlined;
    case 'sports-accessories':
      return Icons.sports_basketball_outlined;
    case 'motorcycle':
    case 'vehicle':
      return Icons.directions_car_outlined;
    case 'kitchen-accessories':
      return Icons.kitchen_outlined;
    default:
      return Icons.category_outlined;
  }
}

Color categoryColor(String slug) {
  switch (slug) {
    case 'beauty':
    case 'skin-care':
      return const Color(0xffE91E8C);
    case 'fragrances':
      return const Color(0xff9C27B0);
    case 'furniture':
    case 'home-decoration':
      return const Color(0xff795548);
    case 'groceries':
      return const Color(0xff4CAF50);
    case 'laptops':
    case 'tablets':
    case 'smartphones':
    case 'mobile-accessories':
      return const Color(0xff2196F3);
    case 'mens-shirts':
    case 'mens-shoes':
    case 'tops':
    case 'womens-dresses':
    case 'womens-bags':
    case 'womens-shoes':
      return const Color(0xffFF5722);
    case 'mens-watches':
    case 'womens-watches':
    case 'womens-jewellery':
    case 'sunglasses':
      return const Color(0xffFFB300);
    case 'sports-accessories':
      return const Color(0xff00BCD4);
    case 'motorcycle':
    case 'vehicle':
      return const Color(0xff607D8B);
    case 'kitchen-accessories':
      return const Color(0xffFF9800);
    default:
      return brandPrimary;
  }
}
