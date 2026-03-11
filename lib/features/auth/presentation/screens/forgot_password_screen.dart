import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: PremiumCard(
              child: Text(
                'Forgot Password Screen\n\nPhase 7 will implement reset OTP request flow.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}