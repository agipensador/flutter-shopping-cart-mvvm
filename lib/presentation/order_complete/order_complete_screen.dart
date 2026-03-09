import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/cart_store.dart';
import '../../shared/widgets/app_button.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Pedido Completo',
          style: AppTextStyles.title.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AppButton(
            label: 'Novo pedido',
            onPressed: () {
              context.read<CartStore>().clear();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.catalog,
                (_) => false,
              );
            },
          ),
        ),
      ),
    );
  }
}
