import 'dart:math';

import '../../core/result/result.dart';

class CartApi {
  CartApi() : _random = Random();

  final Random _random;
  static const Duration _delay = Duration(milliseconds: 300);
  static const double _errorChance = 0.15;

  Future<Result<bool>> addItem(int productId, int quantity) async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      return Result.failure('Erro ao adicionar item');
    }
    return Result.success(true);
  }

  Future<Result<bool>> removeItem(int productId) async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      return Result.failure('Erro ao remover item');
    }
    return Result.success(true);
  }

  Future<Result<bool>> updateQuantity(int productId, int quantity) async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      return Result.failure('Erro ao atualizar quantidade');
    }
    return Result.success(true);
  }
}
