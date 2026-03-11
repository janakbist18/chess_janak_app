import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: PremiumCard(
              child: Text(
                'Reset Password Screen\n\nPhase 7 will implement OTP + new password reset form.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}