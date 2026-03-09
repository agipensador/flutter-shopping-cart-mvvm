import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/routes/app_routes.dart';

class CheckoutAnimationScreen extends StatefulWidget {
  const CheckoutAnimationScreen({super.key});

  @override
  State<CheckoutAnimationScreen> createState() => _CheckoutAnimationScreenState();
}

class _CheckoutAnimationScreenState extends State<CheckoutAnimationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.orderComplete);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/shopping_cart.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
