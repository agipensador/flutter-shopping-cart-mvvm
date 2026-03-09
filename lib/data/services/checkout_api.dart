import 'dart:math';

import '../../core/result/result.dart';

class CheckoutApi {
  CheckoutApi() : _random = Random();

  final Random _random;
  static const Duration _delay = Duration(milliseconds: 500);
  static const double _errorChance = 0.15;

  Future<Result<bool>> checkout() async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      return Result.failure('Erro ao finalizar pedido');
    }
    return Result.success(true);
  }
}
