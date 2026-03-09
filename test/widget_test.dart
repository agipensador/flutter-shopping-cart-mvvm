// Smoke test do app de carrinho de compras.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_carrinho_de_compras/main.dart';

void main() {
  testWidgets('App carrega e exibe tela de catálogo', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Catálogo'), findsOneWidget);
  });
}
