import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/products/data-model/product.model.dart';
import 'package:giftpose_app/modules/products/view-model/products-view-model.dart';
import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/sizes.dart';
import 'package:giftpose_app/theme/text-styles.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(context, listen: false)
          .fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: brandSurface,
      body: Consumer<ProductViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoadingDetail) {
            return const Scaffold(
              backgroundColor: brandSurface,
              body: Center(
                child: CircularProgressIndicator(
                    color: brandAccent, strokeWidth: 2.5),
              ),
            );
          }

          final product = vm.selectedProduct;
          if (product == null) return const SizedBox.shrink();

          final hasDiscount = product.discountPercentage > 0;
          final isInStock = product.availabilityStatus == 'In Stock';

          return Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Image App Bar ─────────────────────────────
                  SliverAppBar(
                    expandedHeight: size.height * 0.42,
                    pinned: true,
                    backgroundColor: brandPrimary,
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_ios_rounded,
                            color: brandPrimary, size: 16),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border_rounded,
                              color: brandPrimary, size: 18),
                          onPressed: () {},
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            product.images.isNotEmpty
                                ? product.images[_selectedImageIndex]
                                : product.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xffF3F3F8),
                              child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Color(0xffC0C0D0),
                                  size: 40),
                            ),
                          ),
                          // Fade to background at bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    brandSurface,
                                    brandSurface.withOpacity(0)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Thumbnail strip
                          if (product.images.length > 1)
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  product.images.length,
                                  (i) => GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedImageIndex = i),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      width: _selectedImageIndex == i ? 32 : 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: _selectedImageIndex == i
                                              ? brandAccent
                                              : Colors.white.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(product.images[i],
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (hasDiscount)
                            Positioned(
                              top: 100,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: brandRed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "-${product.discountPercentage.toStringAsFixed(0)}% OFF",
                                  style: badgeStyle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ── Product Info ──────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category + availability
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product.category.toUpperCase(),
                                  style: categoryLabelStyle),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isInStock
                                      ? Colors.green.withOpacity(0.1)
                                      : brandRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color:
                                            isInStock ? Colors.green : brandRed,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      product.availabilityStatus,
                                      style: captionStyle.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color:
                                            isInStock ? Colors.green : brandRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Title
                          Text(product.title, style: displayStyle),
                          const SizedBox(height: 6),

                          // Brand
                          if (product.brand != null)
                            Text("by ${product.brand}",
                                style: captionStyle.copyWith(
                                    fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),

                          // Rating
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                final full = i < product.rating.floor();
                                final half = !full &&
                                    i < product.rating &&
                                    product.rating - i > 0;
                                return Icon(
                                  full
                                      ? Icons.star_rounded
                                      : half
                                          ? Icons.star_half_rounded
                                          : Icons.star_outline_rounded,
                                  color: brandAccent,
                                  size: 18,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(product.rating.toStringAsFixed(1),
                                  style: bodyText1Style.copyWith(
                                      color: brandTextPrimary)),
                              const SizedBox(width: 6),
                              Text("(${product.reviews.length} reviews)",
                                  style: captionStyle),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Price row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${product.discountedPrice.toStringAsFixed(2)}",
                                style: priceStyle,
                              ),
                              if (hasDiscount) ...[
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    "\$${product.price.toStringAsFixed(2)}",
                                    style: priceStrikeStyle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: brandRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Save \$${(product.price - product.discountedPrice).toStringAsFixed(2)}",
                                      style: captionStyle.copyWith(
                                          color: brandRed,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Quantity selector
                          Row(
                            children: [
                              Text("Quantity",
                                  style: sectionTitleStyle.copyWith(
                                      fontSize: ts3)),
                              const SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.15)),
                                ),
                                child: Row(
                                  children: [
                                    _QuantityButton(
                                      icon: Icons.remove_rounded,
                                      onTap: () {
                                        if (_quantity > 1)
                                          setState(() => _quantity--);
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text("$_quantity",
                                          style: quantityStyle),
                                    ),
                                    _QuantityButton(
                                      icon: Icons.add_rounded,
                                      onTap: () => setState(() => _quantity++),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${product.stock} left",
                                style: product.stock < 10
                                    ? stockWarningStyle
                                    : stockSafeStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Divider(color: Colors.grey.withOpacity(0.12)),
                          const SizedBox(height: 16),

                          // Description
                          Text("Description", style: sectionTitleStyle),
                          const SizedBox(height: 8),
                          Text(product.description, style: bodyStyle),
                          const SizedBox(height: 20),

                          // Info cards
                          Row(
                            children: [
                              _InfoCard(
                                icon: Icons.local_shipping_outlined,
                                title: "Shipping",
                                value: product.shippingInformation ?? "N/A",
                              ),
                              const SizedBox(width: 10),
                              _InfoCard(
                                icon: Icons.assignment_return_outlined,
                                title: "Returns",
                                value: product.returnPolicy ?? "N/A",
                              ),
                              const SizedBox(width: 10),
                              _InfoCard(
                                icon: Icons.verified_outlined,
                                title: "Warranty",
                                value: product.warrantyInformation ?? "N/A",
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Tags
                          if (product.tags.isNotEmpty) ...[
                            Text("Tags", style: sectionTitleStyle),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: product.tags
                                  .map((tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: brandPrimary.withOpacity(0.07),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color:
                                                brandPrimary.withOpacity(0.15),
                                          ),
                                        ),
                                        child: Text("#$tag", style: tagStyle),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          Divider(color: Colors.grey.withOpacity(0.12)),
                          const SizedBox(height: 16),

                          // Reviews
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Reviews", style: sectionTitleStyle),
                              Text("${product.reviews.length} total",
                                  style: captionStyle),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...product.reviews
                              .map((r) => _ReviewCard(review: r))
                              .toList(),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── Sticky Bottom Bar ─────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: brandPrimary, width: 1.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shopping_bag_outlined,
                                      color: brandPrimary, size: 18),
                                  const SizedBox(width: 8),
                                  Text("Add to Cart",
                                      style: buttonStyle.copyWith(
                                          color: brandPrimary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: brandPrimary,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: brandPrimary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text("Buy Now", style: buttonStyle),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: brandPrimary, size: 18),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoCard(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: brandAccent, size: 20),
            const SizedBox(height: 5),
            Text(title, style: infoCardTitleStyle),
            const SizedBox(height: 3),
            Text(value,
                style: infoCardValueStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProductReview review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: brandPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        review.reviewerName.isNotEmpty
                            ? review.reviewerName[0].toUpperCase()
                            : "?",
                        style: bodyText1Style.copyWith(color: brandPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.reviewerName, style: reviewerNameStyle),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < review.rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: brandAccent,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(_formatDate(review.date), style: captionStyle),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.comment, style: reviewBodyStyle),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return "${date.day} ${months[date.month]} ${date.year}";
    } catch (_) {
      return dateStr;
    }
  }
}
