// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/products/data-model/product.model.dart';
import 'package:giftpose_app/modules/products/view-model/products-view-model.dart';
import 'package:giftpose_app/modules/products/views/widgets/store-products-tab-item.dart';
import 'package:provider/provider.dart';

class TrendingProducts extends StatelessWidget {
  final List<Product> products;
  const TrendingProducts({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return CarouselSlider.builder(
      itemCount: products.length,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.41,
        viewportFraction: 0.48,
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 700),
        autoPlayCurve: Curves.easeInOutCubic,
        enableInfiniteScroll: true,
        padEnds: false,
      ),
      itemBuilder: (_, index, __) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 4, bottom: 6),
        child: StoreProductTabItem(product: products[index]),
      ),
    );
  }
}
