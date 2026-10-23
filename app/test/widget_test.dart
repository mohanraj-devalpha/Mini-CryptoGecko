import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('CoinScopeApp boots and renders navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CoinScopeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Coins'), findsWidgets);
    expect(find.text('Market'), findsWidgets);
    expect(find.text('Watchlist'), findsWidgets);
  });
}
