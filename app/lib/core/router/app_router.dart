import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../network/network_providers.dart';
import '../widgets/waking_up_banner.dart';
import '../../features/coins/ui/coins_screen.dart';
import '../../features/coin_detail/ui/coin_detail_screen.dart';
import '../../features/market/ui/market_screen.dart';
import '../../features/watchlist/ui/watchlist_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorCoinsKey = GlobalKey<NavigatorState>();
final _shellNavigatorMarketKey = GlobalKey<NavigatorState>();
final _shellNavigatorWatchlistKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/coins',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCoinsKey,
            routes: [
              GoRoute(
                path: '/coins',
                builder: (context, state) => const CoinsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMarketKey,
            routes: [
              GoRoute(
                path: '/market',
                builder: (context, state) => const MarketScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorWatchlistKey,
            routes: [
              GoRoute(
                path: '/watchlist',
                builder: (context, state) => const WatchlistScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/coin/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CoinDetailScreen(coinId: id);
        },
      ),
    ],
  );
});

class ScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slowNotifier = ref.watch(slowRequestNotifierProvider);

    return Scaffold(
      body: Column(
        children: [
          WakingUpBanner(visible: slowNotifier.isWakingUp),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.currency_bitcoin_rounded),
            selectedIcon: Icon(Icons.currency_bitcoin_rounded),
            label: 'Coins',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }
}
