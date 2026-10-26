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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Markets'), findsWidgets);
    expect(find.text('Watchlist'), findsWidgets);
  });
}
