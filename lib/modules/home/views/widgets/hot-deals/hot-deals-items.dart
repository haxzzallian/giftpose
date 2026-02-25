import 'package:giftpose_app/common/widgets/height-spacer.dart';
import 'package:giftpose_app/modules/home/views/widgets/hot-deals/hot-deals.model.dart';
import 'package:giftpose_app/modules/products/data-model/product.model.dart';
import 'package:giftpose_app/modules/products/views/product-details.dart';
import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/text-styles.dart';
import 'package:flutter/material.dart';

class HotDealsItem extends StatelessWidget {
  final Product? product;
  const HotDealsItem({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(
              productId: product!.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: brandCard,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product?.thumbnail ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xffF3F3F8),
                        child: const Icon(Icons.image_not_supported_outlined,
                            color: Color(0xffC0C0D0), size: 16),
                      ),
                    ),
                  ),
                  // Amber corner accent
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: brandAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: const Text("🔥", style: TextStyle(fontSize: 9)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product?.title ?? "",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: brandTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          "\$${product?.discountedPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: brandPrimary,
                          ),
                        ),
                        if ((product?.discountPercentage ?? 0) > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            "\$${product?.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 8,
                              color: brandTextSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
