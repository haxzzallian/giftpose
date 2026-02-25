import 'package:giftpose_app/modules/home/views/widgets/hot-deals/hot-deals-items.dart';
import 'package:giftpose_app/modules/home/views/widgets/hot-deals/hot-deals.model.dart';
import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/products/data-model/product.model.dart';

class HotDeals extends StatelessWidget {
  final List<Product> products;
  const HotDeals({super.key, required this.products});

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
        childAspectRatio: 0.72,
        children: display.map((p) => HotDealsItem(product: p)).toList(),
      ),
    );
  }
}
