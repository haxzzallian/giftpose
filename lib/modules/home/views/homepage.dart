import 'package:giftpose_app/modules/home/views/bottom-nav.dart';

import 'package:giftpose_app/modules/home/views/widgets/hot-deals/hot-deals.dart';

import 'package:giftpose_app/modules/home/views/widgets/promotions/promotion.dart';
import 'package:giftpose_app/modules/home/views/widgets/search-box.dart';
import 'package:giftpose_app/modules/home/views/widgets/trending-products.dart';
import 'package:giftpose_app/modules/products/view-model/products-view-model.dart';
import 'package:giftpose_app/modules/products/views/category-products-screen.dart';
import 'package:giftpose_app/modules/products/views/widgets/category-grid-item.dart';
import 'package:giftpose_app/modules/products/views/widgets/store-products-tab-item.dart';

import 'package:giftpose_app/theme/colors.dart';

import 'package:flutter/material.dart';
import 'package:giftpose_app/theme/text-styles.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll listener for infinite scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        Provider.of<ProductViewModel>(context, listen: false)
            .loadMoreProducts();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<ProductViewModel>(context, listen: false);
      vm.fetchProducts(refresh: true);
      vm.fetchCategories(refresh: true);
      vm.fetchPaginatedProducts(refresh: true); // ADD THIS
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // ADD
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: brandSurface,
      bottomNavigationBar: BottomNav(selectedIndex: 0),
      body: SafeArea(
        child: Consumer<ProductViewModel>(
          builder: (context, vm, _) {
            return RefreshIndicator(
              color: brandAccent,
              backgroundColor: brandPrimary,
              onRefresh: () => vm.fetchProducts(refresh: true),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header
                  SliverToBoxAdapter(child: _buildHeader()),

                  // Hero banner
                  SliverToBoxAdapter(
                    child: _buildHeroBanner(screenHeight),
                  ),

                  // Categories chips
                  SliverToBoxAdapter(child: _buildCategoryChips()),

                  if (vm.isBusy)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: brandAccent,
                                strokeWidth: 2.5,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "Loading products...",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  color: brandTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else ...[
                    // Active category tag
                    SliverToBoxAdapter(
                      child: Consumer<ProductViewModel>(
                        builder: (context, vm, _) {
                          if (vm.selectedCategory != null) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Showing: ",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      color: brandTextSecondary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: brandPrimary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          vm.selectedCategory!.name,
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        GestureDetector(
                                          onTap: () => vm.selectCategory(null),
                                          child: const Icon(Icons.close_rounded,
                                              color: brandAccent, size: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    // Trending — collapses if empty
                    if (vm.trendingProducts.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                            title: "Trending Now",
                            label: "HOT",
                            onSeeMore: () {}),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: screenHeight * 0.41,
                          child:
                              TrendingProducts(products: vm.trendingProducts),
                        ),
                      ),
                    ],

                    // New Arrivals — collapses if empty
                    if (vm.newArrivals.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                            title: "New Arrivals",
                            label: "NEW",
                            onSeeMore: () {}),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) =>
                                StoreProductTabItem(product: vm.newArrivals[i]),
                            childCount: vm.newArrivals.length.clamp(0, 6),
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

                    // Categories Grid section
                    if (vm.categories.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                            title: "Shop by Category",
                            label: "ALL",
                            onSeeMore: () {}),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) => CategoryGridItem(
                              category: vm.categories[i],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryProductsScreen(
                                      category: vm.categories[i],
                                    ),
                                  ),
                                );
                              },
                            ),
                            childCount: vm.categories.length.clamp(0, 12),
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.0,
                          ),
                        ),
                      ),
                    ],

                    // Promotions — collapses if empty
                    if (vm.promotions.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                            title: "Promotions",
                            label: "SALE",
                            onSeeMore: () {}),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: screenHeight * 0.45,
                          child: Promotion(products: vm.promotions),
                        ),
                      ),
                    ],

                    // Hot Deals — collapses if empty
                    if (vm.hotDeals.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                            title: "Hot Deals", label: "🔥", onSeeMore: () {}),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: screenHeight * 0.50,
                          child: HotDeals(products: vm.hotDeals),
                        ),
                      ),
                    ],

                    // Infinite Scroll — "All Products" section
                    SliverToBoxAdapter(
                      child: _SectionHeader(
                        title: "All Products",
                        label: "NEW",
                        onSeeMore: () {},
                      ),
                    ),

// Products list — staggered card layout
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => StoreProductTabItem(
                            product: vm.paginatedProducts[i],
                          ),
                          childCount: vm.paginatedProducts.length,
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

// Loading indicator at bottom
                    SliverToBoxAdapter(
                      child: vm.isLoadingMore
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  const CircularProgressIndicator(
                                    color: brandAccent,
                                    strokeWidth: 2.5,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Loading more products...",
                                    style: captionStyle,
                                  ),
                                ],
                              ),
                            )
                          : vm.hasMore
                              ? const SizedBox(height: 20)
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Column(
                                    children: [
                                      Divider(
                                          color: Colors.grey.withOpacity(0.2)),
                                      const SizedBox(height: 12),
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: brandAccent,
                                        size: 28,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "You've seen all products",
                                        style: captionStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: brandTextPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${vm.paginatedProducts.length} products total",
                                        style: captionStyle,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                    ),

                    // If ALL sections are empty after filtering, show a friendly message
                    if (vm.trendingProducts.isEmpty &&
                        vm.newArrivals.isEmpty &&
                        vm.promotions.isEmpty &&
                        vm.hotDeals.isEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: screenHeight * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined,
                                  size: 52,
                                  color: brandTextSecondary.withOpacity(0.4)),
                              const SizedBox(height: 14),
                              Text(
                                "No products found",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: brandTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Try a different category",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  color: brandTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () => vm.selectCategory(null),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: brandPrimary,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Text(
                                    "View All Products",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 28)),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: brandSurface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GIFT POSE",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: brandPrimary,
                      letterSpacing: 2.5,
                    ),
                  ),
                  Text(
                    "Premium Marketplace",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      color: brandAccent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Post Ad
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: brandPrimary,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: brandPrimary.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_rounded,
                              color: brandAccent, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            "Post Ad",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Notification
                  GestureDetector(
                    onTap: () {},
                    child: Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: brandPrimary,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(Icons.notifications_outlined,
                              color: Colors.white, size: 19),
                        ),
                        Positioned(
                          right: 9,
                          top: 9,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: brandAccent,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: brandPrimary, width: 1.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Menu button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: brandPrimary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.menu_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(child: SearchBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(double screenHeight) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      height: screenHeight * 0.20,
      decoration: BoxDecoration(
        color: brandPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: brandPrimary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative amber blob
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandAccent.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandAccent.withOpacity(0.08),
              ),
            ),
          ),
          // Amber vertical stripe accent
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                color: brandAccent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: brandAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "LIMITED TIME",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: brandAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Up to 50% Off\nToday's Picks",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: brandAccent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Text(
                            "Shop Now  →",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: brandPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
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
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Consumer<ProductViewModel>(
      builder: (context, vm, _) {
        // Build chip list: "All" + fetched categories
        final bool hasCategories = vm.categories.isNotEmpty;

        return SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            scrollDirection: Axis.horizontal,
            // +1 for the "All" chip
            itemCount: hasCategories ? vm.categories.length + 1 : 5,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              // Loading shimmer placeholders
              if (!hasCategories) {
                return Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }

              // "All" chip at index 0
              final isAll = i == 0;
              final isSelected = isAll
                  ? vm.selectedCategory == null
                  : vm.selectedCategory?.slug == vm.categories[i - 1].slug;

              final label = isAll ? "All" : vm.categories[i - 1].name;
              final icon = isAll
                  ? Icons.grid_view_rounded
                  : categoryIcon(vm.categories[i - 1].slug);

              return GestureDetector(
                onTap: () {
                  vm.selectCategory(isAll ? null : vm.categories[i - 1]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? brandPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? brandPrimary
                          : Colors.grey.withOpacity(0.2),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: brandPrimary.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 13,
                        color: isSelected ? brandAccent : brandTextSecondary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : brandTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final String label;
  final VoidCallback? onSeeMore;

  const _SectionHeader({
    required this.title,
    required this.label,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: brandTextPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: label == "🔥"
                      ? Colors.orange.withOpacity(0.12)
                      : label == "SALE"
                          ? brandRed.withOpacity(0.1)
                          : brandAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: label == "🔥" ? 11 : 8,
                    fontWeight: FontWeight.w800,
                    color: label == "🔥"
                        ? Colors.orange
                        : label == "SALE"
                            ? brandRed
                            : brandAccent,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onSeeMore,
            child: Row(
              children: [
                Text(
                  "See all",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: brandPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 10, color: brandPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
