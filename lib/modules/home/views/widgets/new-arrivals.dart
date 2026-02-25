import 'package:giftpose_app/modules/products/data-model/product.model.dart';
import 'package:giftpose_app/modules/products/view-model/products-view-model.dart';
import 'package:giftpose_app/modules/products/views/widgets/store-products-tab-item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewArrivals extends StatelessWidget {
  final List<Product> products;

  const NewArrivals({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      childAspectRatio: 0.58,
      children: List.generate(
        products.length > 6 ? 6 : products.length,
        (index) => StoreProductTabItem(product: products[index]),
      ),
    );
  }
}