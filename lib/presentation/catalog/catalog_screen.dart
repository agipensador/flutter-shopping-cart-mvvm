import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/helpers/snackbar_helper.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/models/product.dart';
import '../../domain/cart_store.dart';
import 'catalog_viewmodel.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/delete_item_confirmation_dialog.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/quantity_selector.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogViewModel>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'Catálogo',
          style: AppTextStyles.title.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Consumer<CartStore>(
            builder: (context, cartStore, _) {
              final count = cartStore.distinctCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<CatalogViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'OPS! Erro ao carregar o App',
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Tente novamente',
                      onPressed: () => viewModel.loadProducts(),
                      backgroundColor: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            );
          }
          if (viewModel.products.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.products.length,
            itemBuilder: (context, index) {
              final product = viewModel.products[index];
              return _ProductTile(product: product);
            },
          );
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartStore>(
      builder: (context, cartStore, _) {
        final quantity = cartStore.getQuantity(product.id);
        final viewModel = context.read<CatalogViewModel>();
        return ProductCard(
          product: product,
          trailing: QuantitySelector(
            quantity: quantity,
            onAddToCart: quantity == 0 ? () => _addToCart(context, viewModel) : null,
            onDecrement: () => _decrementQuantity(context, viewModel),
            onIncrement: () => _incrementQuantity(context, viewModel),
          ),
        );
      },
    );
  }

  Future<void> _addToCart(BuildContext context, CatalogViewModel viewModel) async {
    try {
      final added = await viewModel.addToCart(product);
      if (!context.mounted) return;
      if (added) {
        SnackBarHelper.showSuccess(context, 'Produto adicionado');
      } else {
        SnackBarHelper.showError(context, 'Você não pode adicionar mais itens');
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> _decrementQuantity(BuildContext context, CatalogViewModel viewModel) async {
    if (context.read<CartStore>().getQuantity(product.id) == 1) {
      final confirmed = await DeleteItemConfirmationDialog.show(context, product.title);
      if (!context.mounted || confirmed != true) return;
    }
    try {
      await viewModel.decrementQuantity(product);
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> _incrementQuantity(BuildContext context, CatalogViewModel viewModel) async {
    try {
      final added = await viewModel.incrementQuantity(product);
      if (!context.mounted) return;
      if (!added) {
        SnackBarHelper.showError(context, 'Você não pode adicionar mais itens');
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }
}
