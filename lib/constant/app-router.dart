import 'package:giftpose_app/modules/home/views/bottom-nav.dart';
import 'package:giftpose_app/modules/home/views/homepage.dart';

import 'package:flutter/material.dart';
import 'package:giftpose_app/modules/home/views/placeholders.dart';

import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String homepage = "/homepage";
  static const String cart = "/cart";
  static const String wishlist = "/wishlist";
  static const String profile = "/profile";
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.homepage,
  routes: [
    GoRoute(
      path: AppRoutes.homepage,
      pageBuilder: (context, state) => MaterialPage(child: Homepage()),
    ),
    GoRoute(
      path: AppRoutes.cart,
      pageBuilder: (context, state) => const MaterialPage(child: MyCart()),
    ),
    GoRoute(
      path: AppRoutes.wishlist,
      pageBuilder: (context, state) =>
          const MaterialPage(child: WishlistScreen()),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfileScreen()),
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => BottomNav(
        selectedIndex: 0,
      ),
    ),
  ],
);
