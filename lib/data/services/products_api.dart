import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../core/result/result.dart';
import '../dtos/product_dto.dart';
import '../../domain/models/product.dart';

class ProductsApi {
  ProductsApi({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://fakestoreapi.com';
  static const Duration _delay = Duration(milliseconds: 500);
  static const double _errorChance = 0.15;
  static const int _successStatus = 200;

  final http.Client _client;
  final Random _random = Random();

  Future<Result<List<Product>>> getProducts() async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      return Result.failure('Erro ao carregar produtos');
    }
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/products'));
      if (response.statusCode != _successStatus) {
        return Result.failure('Erro ao carregar produtos');
      }
      final list = json.decode(response.body) as List<dynamic>;
      final products = list
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Result.success(products);
    } catch (e) {
      return Result.failure(e.toString().replaceFirst('Exception: ao carregar produtos $e', ''));
    }
  }
}
