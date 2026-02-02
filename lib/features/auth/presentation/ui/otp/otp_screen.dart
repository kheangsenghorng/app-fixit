import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../data/auth_repository.dart';
import '../../providers/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  final String password;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.password,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  Timer? _timer;
  int _secondsRemaining = 300; // 5 Minutes
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer([int seconds = 300]) {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = seconds;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final themeColor = const Color(0xFF0056D2);

    ref.listen(authControllerProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (_) => false);
      }
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString()), backgroundColor: Colors.redAccent),
          );
        },
      );
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 62,
      textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeColor),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.white,
        border: Border.all(color: themeColor, width: 2),
        boxShadow: [
          BoxShadow(color: themeColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: themeColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text("fixit", style: TextStyle(color: themeColor, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.shield_outlined, color: themeColor, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                "Verification Code",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  children: [
                    const TextSpan(text: "Enter the 5-digit code sent to\n"),
                    TextSpan(
                      text: widget.phone,
                      style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Pinput(
                length: 5,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                separatorBuilder: (index) => const SizedBox(width: 10),
                onCompleted: (pin) async {
                  await ref.read(authControllerProvider.notifier).verifyOtp(
                    phone: widget.phone,
                    code: pin,
                    password: widget.password,
                  );
                },
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: authState.isLoading || _secondsRemaining == 0
                      ? null
                      : () async {
                    await ref.read(authControllerProvider.notifier).verifyOtp(
                      phone: widget.phone,
                      code: pinController.text,
                      password: widget.password,
                    );
                  },
                  child: authState.isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Verify Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 18, color: _canResend ? Colors.grey : themeColor),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(_secondsRemaining),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _canResend ? Colors.grey : themeColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: !_canResend
                    ? null
                    : () async {
                  pinController.clear();

                  // 1. Perform async request
                  await ref.read(authRepositoryProvider).sendOtp(widget.phone);

                  // 2. CHECK MOUNTED before using context (fixes the warning)
                  if (!mounted) return;

                  _startTimer(300);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("A new code has been sent")),
                  );
                },
                child: Text(
                  "Didn't receive code? Send again",
                  style: TextStyle(
                    color: _canResend ? themeColor : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: _canResend ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}