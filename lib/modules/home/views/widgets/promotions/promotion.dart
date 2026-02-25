import 'package:giftpose_app/modules/home/views/widgets/promotions/promotion-item.dart';
import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/products/data-model/product.model.dart';

class Promotion extends StatelessWidget {
  final List<Product> products;
  const Promotion({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final display = products.length > 6 ? products.sublist(0, 6) : products;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.78,
        children: display.map((p) => PromotionItem(product: p)).toList(),
      ),
    );
  }
}
