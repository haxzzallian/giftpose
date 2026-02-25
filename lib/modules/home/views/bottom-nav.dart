import 'package:flutter/material.dart';
import 'package:giftpose_app/constant/app-router.dart';
import 'package:giftpose_app/modules/home/views/placeholders.dart';
import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/text-styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  final int selectedIndex;

  const BottomNav({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _animationController;

  final List<_NavItem> _items = const [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: "Home",
    ),
    _NavItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      label: "Cart",
    ),
    _NavItem(
      icon: Icons.favorite_outline_rounded,
      activeIcon: Icons.favorite_rounded,
      label: "Wishlist",
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: "Profile",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _animationController.forward(from: 0);
    _navigate(index);
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.homepage);
        break;
      case 1:
        context.go(AppRoutes.cart);
        break;
      case 2:
        context.go(AppRoutes.wishlist);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (i) => _NavButton(
                item: _items[i],
                isSelected: _currentIndex == i,
                onTap: () => _onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Nav item data class
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// Individual nav button with animation
class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: -4.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.isSelected) _controller.forward();
  }

  @override
  void didUpdateWidget(_NavButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox(
                width: 70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon container with animated pill background
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isSelected ? 16 : 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? brandPrimary.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        widget.isSelected
                            ? widget.item.activeIcon
                            : widget.item.icon,
                        size: 24,
                        color: widget.isSelected
                            ? brandPrimary
                            : brandTextSecondary.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Animated label
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: captionStyle.copyWith(
                        fontSize: 10,
                        fontWeight: widget.isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: widget.isSelected
                            ? brandPrimary
                            : brandTextSecondary.withOpacity(0.6),
                      ),
                      child: Text(widget.item.label),
                    ),
                    // Active dot indicator
                    const SizedBox(height: 3),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      width: widget.isSelected ? 16 : 0,
                      height: widget.isSelected ? 3 : 0,
                      decoration: BoxDecoration(
                        color: brandAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
