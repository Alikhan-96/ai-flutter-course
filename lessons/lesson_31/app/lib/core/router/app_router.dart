import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/product_list_page.dart';
import '../../presentation/pages/product_detail_page.dart';
import '../../presentation/pages/settings_page.dart';

/// App router configuration using go_router
class AppRouter {
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: products,
        name: 'products',
        builder: (context, state) {
          // Query parameters demo
          final category = state.uri.queryParameters['category'];
          return ProductListPage(category: category);
        },
      ),
      GoRoute(
        path: productDetail,
        name: 'product-detail',
        builder: (context, state) {
          // Path parameters demo
          final id = int.parse(state.pathParameters['id']!);
          // Optional query parameter
          final from = state.uri.queryParameters['from'] ?? 'unknown';
          return ProductDetailPage(productId: id, from: from);
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
