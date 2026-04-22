import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentQrPage extends StatefulWidget {
  final String base64Image;
  final String? deeplink;
  final Future<String?> Function() onCheckPayment;

  const PaymentQrPage({
    super.key,
    required this.base64Image,
    required this.onCheckPayment,
    this.deeplink,
  });

  @override
  State<PaymentQrPage> createState() => _PaymentQrPageState();
}

class _PaymentQrPageState extends State<PaymentQrPage> {
  bool _isChecking = true;
  bool _isExpired = false;
  bool _isOpeningDeeplink = false;
  String? _errorMessage;
  Timer? _timer;
  int _attempt = 0;

  static const int _maxAttempts = 40;
  static const int _intervalSeconds = 3;

  @override
  void initState() {
    super.initState();
    _startCheckingPayment();
  }

  Future<void> _startCheckingPayment() async {
    _timer = Timer.periodic(const Duration(seconds: _intervalSeconds), (timer) async {
      if (!_isChecking) {
        timer.cancel();
        return;
      }

      _attempt++;

      try {
        final externalRef = await widget.onCheckPayment();

        if (externalRef != null && externalRef.isNotEmpty) {
          _isChecking = false;
          timer.cancel();

          if (!mounted) return;
          Navigator.pop(context, externalRef);
          return;
        }

        if (_attempt >= _maxAttempts) {
          _isChecking = false;
          _isExpired = true;
          timer.cancel();

          if (mounted) {
            setState(() {});
          }
        } else {
          if (mounted) {
            setState(() {});
          }
        }
      } catch (e) {
        debugPrint('Check payment error: $e');

        if (_attempt >= _maxAttempts) {
          _isChecking = false;
          _errorMessage = e.toString();
          timer.cancel();

          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  Future<void> _openDeeplink() async {
    final link = widget.deeplink;

    if (link == null || link.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bakong deeplink not found'),
        ),
      );
      return;
    }

    setState(() {
      _isOpeningDeeplink = true;
    });

    try {
      final uri = Uri.parse(link);

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Bakong app'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open deeplink: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningDeeplink = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _countdownText {
    final totalSeconds = _maxAttempts * _intervalSeconds;
    final remainingSeconds =
    (totalSeconds - (_attempt * _intervalSeconds)).clamp(0, totalSeconds);
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final raw = widget.base64Image.contains(',')
        ? widget.base64Image.split(',').last
        : widget.base64Image;

    final svgString = utf8.decode(base64Decode(raw));

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: SizedBox(
                height: 52,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'KHQR Payment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                            child: Center(
                              child: SizedBox(
                                width: 460,
                                height: 460,
                                child: SvgPicture.string(
                                  svgString,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      _isExpired
                          ? 'QR expired'
                          : '$_countdownText | QR will be expired',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isExpired ? Colors.red : Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                        ),
                      ),
                    ],
                    const SizedBox(height: 26),
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            'Or',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isExpired || _isOpeningDeeplink
                            ? null
                            : _openDeeplink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED1C24),
                          disabledBackgroundColor:
                          const Color(0xFFED1C24).withOpacity(0.6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: _isOpeningDeeplink
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Pay via Bakong App',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (_isChecking) ...[
                      const SizedBox(height: 20),
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}