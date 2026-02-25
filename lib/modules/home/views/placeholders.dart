import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/home/views/bottom-nav.dart';
import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/text-styles.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandSurface,
      bottomNavigationBar: BottomNav(selectedIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Text("My Cart", style: displayStyle.copyWith(fontSize: 22)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: brandPrimary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("0 items",
                        style: captionStyle.copyWith(
                            color: brandPrimary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Center(
              child: Text("My Cart"),
            )
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandSurface,
      bottomNavigationBar: BottomNav(selectedIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Text("Wishlist", style: displayStyle.copyWith(fontSize: 22)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: brandRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("0 saved",
                        style: captionStyle.copyWith(
                            color: brandRed, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Center(
              child: Text("Wishlist"),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandSurface,
      bottomNavigationBar: BottomNav(selectedIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Text("Wishlist", style: displayStyle.copyWith(fontSize: 22)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: brandRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("0 saved",
                        style: captionStyle.copyWith(
                            color: brandRed, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Center(
              child: Text("Profile"),
            )
          ],
        ),
      ),
    );
  }
}
