import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:app_carrinho_de_compras/core/result/result.dart';
import 'package:app_carrinho_de_compras/core/routes/app_routes.dart';
import 'package:app_carrinho_de_compras/core/theme/app_theme.dart';
import 'package:app_carrinho_de_compras/domain/cart_store.dart';
import 'package:app_carrinho_de_compras/domain/models/product.dart';
import 'package:app_carrinho_de_compras/presentation/catalog/catalog_screen.dart';
import 'package:app_carrinho_de_compras/presentation/catalog/catalog_viewmodel.dart';
import 'package:app_carrinho_de_compras/data/services/products_api.dart';
import 'package:app_carrinho_de_compras/data/services/cart_api.dart';

class FakeProductsApi extends ProductsApi {
  FakeProductsApi({this.products = const []}) : super();

  final List<Product> products;

  @override
  Future<Result<List<Product>>> getProducts() async {
    return Result.success(products);
  }
}

class FakeCartApi extends CartApi {
  @override
  Future<Result<bool>> addItem(int productId, int quantity) async =>
      Result.success(true);

  @override
  Future<Result<bool>> removeItem(int productId) async =>
      Result.success(true);

  @override
  Future<Result<bool>> updateQuantity(int productId, int quantity) async =>
      Result.success(true);
}

Widget buildTestWidget({List<Product> products = const []}) {
  final cartStore = CartStore();
  final productsApi = FakeProductsApi(products: products);
  final cartApi = FakeCartApi();

  return MaterialApp(
    theme: AppTheme.light,
    routes: {
      AppRoutes.catalog: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: cartStore),
              ChangeNotifierProvider(
                create: (_) => CatalogViewModel(
                  api: productsApi,
                  cartApi: cartApi,
                  cartStore: cartStore,
                ),
              ),
            ],
            child: const CatalogScreen(),
          ),
    },
    initialRoute: AppRoutes.catalog,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testProduct = Product(
    id: 1,
    title: 'Test Product',
    price: 10.0,
    imageUrl: 'https://example.com/image.jpg',
  );

  group('CatalogScreen', () {
    testWidgets('adiciona produto ao carrinho ao clicar em Adicionar',
        (WidgetTester tester) async {
      final cartStore = CartStore();
      final productsApi = FakeProductsApi(products: [testProduct]);
      final cartApi = FakeCartApi();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: cartStore),
              ChangeNotifierProvider(
                create: (_) => CatalogViewModel(
                  api: productsApi,
                  cartApi: cartApi,
                  cartStore: cartStore,
                ),
              ),
            ],
            child: const CatalogScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(cartStore.getQuantity(testProduct.id), 0);

      await tester.tap(find.text('Adicionar\nao carrinho'));
      await tester.pumpAndSettle();

      expect(cartStore.getQuantity(testProduct.id), 1);
    });

    testWidgets('badge do carrinho exibe 1 apos adicionar produto',
        (WidgetTester tester) async {
      final cartStore = CartStore();
      final productsApi = FakeProductsApi(products: [testProduct]);
      final cartApi = FakeCartApi();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: cartStore),
              ChangeNotifierProvider(
                create: (_) => CatalogViewModel(
                  api: productsApi,
                  cartApi: cartApi,
                  cartStore: cartStore,
                ),
              ),
            ],
            child: const CatalogScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(AppBar), matching: find.text('1')), findsNothing);

      await tester.tap(find.text('Adicionar\nao carrinho'));
      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(AppBar), matching: find.text('1')), findsOneWidget);
    });
  });
}
