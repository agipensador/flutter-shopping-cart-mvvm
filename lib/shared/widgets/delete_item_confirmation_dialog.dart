import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class DeleteItemConfirmationDialog extends StatelessWidget {
  const DeleteItemConfirmationDialog({
    super.key,
    required this.productName,
  });

  final String productName;

  static Future<bool?> show(BuildContext context, String productName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteItemConfirmationDialog(productName: productName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir item'),
      content: Text(
        'Tem certeza que deseja excluir $productName do seu carrinho?',
        style: AppTextStyles.body,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sim'),
        ),
      ],
    );
  }
}
