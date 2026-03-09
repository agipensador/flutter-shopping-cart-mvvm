import 'package:app_carrinho_de_compras/core/routes/app_routes.dart';
import 'package:app_carrinho_de_compras/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Carrinho',
          style: AppTextStyles.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
        children: [
          Text('Carrinho'),
          AppButton(
            label: 'Finalizar Pedido',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.orderComplete,
                (_) => false,
              );
            },
          ),
        ],      
      )),
    );
  }
}
