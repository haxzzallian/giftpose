import 'package:giftpose_app/common/widgets/height-spacer.dart';

import 'package:giftpose_app/modules/products/data-model/product.model.dart';

import 'package:giftpose_app/modules/products/views/product-details.dart';

import 'package:giftpose_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreProductTabItem extends StatefulWidget {
  final Product? product;
  const StoreProductTabItem({Key? key, this.product}) : super(key: key);

  @override
  State<StoreProductTabItem> createState() => _StoreProductTabItemState();
}

class _StoreProductTabItemState extends State<StoreProductTabItem> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount = (p?.discountPercentage ?? 0) > 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(productId: widget.product!.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: brandCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ADD THIS
          children: [
            // Image — fixed height, not flexible
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    p?.thumbnail ?? "",
                    height: 120, // fixed, not 135
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: const Color(0xffF3F3F8),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: Color(0xffC0C0D0)),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 120,
                        color: const Color(0xffF3F3F8),
                        child: const Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: brandAccent),
                        ),
                      );
                    },
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: brandRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "-${p!.discountPercentage.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: GestureDetector(
                    onTap: () => setState(() => isFavorite = !isFavorite),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite ? brandRed : const Color(0xffC0C0D0),
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info — all fixed sizes, no Spacer or Expanded
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (p?.category != null)
                    Text(
                      p!.category.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: brandAccent,
                        letterSpacing: 1.2,
                      ),
                    ),
                  const SizedBox(height: 3),
                  Text(
                    p?.title ?? "",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: brandTextPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${p?.discountedPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: brandPrimary,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 4),
                        Text(
                          "\$${p?.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 9,
                            color: brandTextSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: brandAccent, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        "${p?.rating.toStringAsFixed(1)}",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: brandTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
