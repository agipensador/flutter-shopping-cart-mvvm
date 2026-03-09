import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'domain/cart_store.dart';
import 'presentation/catalog/catalog_viewmodel.dart';
import 'presentation/cart/cart_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartStore()),
        ChangeNotifierProvider(
          create: (context) => CatalogViewModel(cartStore: context.read<CartStore>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CartViewModel(cartStore: context.read<CartStore>()),
        ),
      ],
      child: MaterialApp(
        title: 'App Carrinho de Compras',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.catalog,
        routes: AppRoutes.routes,
      ),
    );
  }
}
