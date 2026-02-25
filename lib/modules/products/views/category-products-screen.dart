import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/products/data-model/product-category.model.dart';
import 'package:giftpose_app/modules/products/data-model/product.model.dart';
import 'package:giftpose_app/modules/products/view-model/products-view-model.dart';
import 'package:giftpose_app/modules/products/views/widgets/category-grid-item.dart';
import 'package:giftpose_app/modules/products/views/widgets/store-products-tab-item.dart';
import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/text-styles.dart';
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  final ProductCategory category;

  const CategoryProductsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  // Sort options
  String _sortBy = 'default';

  List<Product> _sortedProducts(List<Product> products) {
    final list = [...products];
    switch (_sortBy) {
      case 'price_asc':
        list.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case 'price_desc':
        list.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'discount':
        list.sort(
            (a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      default:
        break;
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(context, listen: false)
          .selectCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(widget.category.slug);
    final icon = categoryIcon(widget.category.slug);

    return Scaffold(
      backgroundColor: brandSurface,
      body: Consumer<ProductViewModel>(
        builder: (context, vm, _) {
          final products = _sortedProducts(vm.filteredProducts);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ──────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 160,
                backgroundColor: brandPrimary,
                leading: GestureDetector(
                  onTap: () {
                    // Clear filter when leaving
                    vm.selectCategory(null);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
                actions: [
                  // Sort button
                  GestureDetector(
                    onTap: () => _showSortSheet(context),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sort_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 5),
                          Text("Sort",
                              style: captionStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [brandPrimary, brandDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative circle
                        Positioned(
                          right: -30,
                          top: -30,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.withOpacity(0.15),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 60,
                          bottom: -20,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: brandAccent.withOpacity(0.1),
                            ),
                          ),
                        ),
                        // Category icon + name
                        Positioned(
                          bottom: 20,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child:
                                    Icon(icon, color: Colors.white, size: 24),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.category.name,
                                style: displayStyle.copyWith(
                                    color: Colors.white, fontSize: 22),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vm.isBusy
                                    ? "Loading..."
                                    : "${products.length} products found",
                                style: captionStyle.copyWith(
                                    color: Colors.white.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Loading state ─────────────────────────────────
              if (vm.isBusy)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                              color: brandAccent, strokeWidth: 2.5),
                          const SizedBox(height: 14),
                          Text("Loading products...", style: captionStyle),
                        ],
                      ),
                    ),
                  ),
                )

              // ── Empty state ───────────────────────────────────
              else if (products.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 56,
                            color: brandTextSecondary.withOpacity(0.35)),
                        const SizedBox(height: 16),
                        Text("No products found", style: sectionTitleStyle),
                        const SizedBox(height: 6),
                        Text(
                          "This category has no products yet",
                          style: captionStyle,
                        ),
                      ],
                    ),
                  ),
                )

              // ── Active sort indicator ─────────────────────────
              else ...[
                if (_sortBy != 'default')
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          Icon(Icons.sort_rounded,
                              size: 14, color: brandAccent),
                          const SizedBox(width: 6),
                          Text(
                            "Sorted by: ${_sortLabel(_sortBy)}",
                            style: captionStyle.copyWith(
                                color: brandAccent,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => setState(() => _sortBy = 'default'),
                            child: Icon(Icons.close_rounded,
                                size: 14, color: brandTextSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Products Grid ───────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => StoreProductTabItem(
                        product: products[i],
                      ),
                      childCount: products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.59,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text("Sort By", style: sectionTitleStyle),
              const SizedBox(height: 16),
              ...[
                ('default', 'Default', Icons.grid_view_rounded),
                ('price_asc', 'Price: Low to High', Icons.arrow_upward_rounded),
                (
                  'price_desc',
                  'Price: High to Low',
                  Icons.arrow_downward_rounded
                ),
                ('rating', 'Highest Rated', Icons.star_rounded),
                ('discount', 'Biggest Discount', Icons.local_offer_rounded),
              ].map(
                (option) => GestureDetector(
                  onTap: () {
                    setState(() => _sortBy = option.$1);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: _sortBy == option.$1
                          ? brandPrimary.withOpacity(0.06)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _sortBy == option.$1
                            ? brandPrimary.withOpacity(0.2)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option.$3,
                          size: 18,
                          color: _sortBy == option.$1
                              ? brandPrimary
                              : brandTextSecondary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option.$2,
                          style: bodyText1Style.copyWith(
                            color: _sortBy == option.$1
                                ? brandPrimary
                                : brandTextPrimary,
                            fontWeight: _sortBy == option.$1
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (_sortBy == option.$1)
                          const Icon(Icons.check_circle_rounded,
                              color: brandPrimary, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _sortLabel(String sort) {
    switch (sort) {
      case 'price_asc':
        return 'Price: Low to High';
      case 'price_desc':
        return 'Price: High to Low';
      case 'rating':
        return 'Highest Rated';
      case 'discount':
        return 'Biggest Discount';
      default:
        return 'Default';
    }
  }
}
