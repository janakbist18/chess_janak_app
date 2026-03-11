import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: PremiumCard(
              child: Text(
                'OTP Verify Screen\n\nPhase 7 will implement OTP input, resend OTP, and verification flow.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}