import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentQrPage extends StatefulWidget {
  final String base64Image;
  final String? deeplink;
  final bool isBakongOnly;
  final Future<String?> Function() onCheckPayment;

  const PaymentQrPage({
    super.key,
    required this.base64Image,
    required this.onCheckPayment,
    this.deeplink,
    this.isBakongOnly = true,
  });

  @override
  State<PaymentQrPage> createState() => _PaymentQrPageState();
}

class _PaymentQrPageState extends State<PaymentQrPage> {
  final GlobalKey _qrKey = GlobalKey();

  bool _isChecking = true;
  bool _isExpired = false;
  bool _isOpeningDeeplink = false;
  bool _hasAutoOpenedDeeplink = false;
  bool _isSharing = false;
  bool _isDownloading = false;

  String? _errorMessage;
  Timer? _timer;
  int _attempt = 0;

  static const int _maxAttempts = 40;
  static const int _intervalSeconds = 3;

  @override
  void initState() {
    super.initState();
    _startCheckingPayment();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isBakongOnly &&
          !_hasAutoOpenedDeeplink &&
          widget.deeplink != null &&
          widget.deeplink!.isNotEmpty) {
        _hasAutoOpenedDeeplink = true;
        await _openDeeplink();
      }
    });
  }

  Future<void> _startCheckingPayment() async {
    _timer = Timer.periodic(
      const Duration(seconds: _intervalSeconds),
          (timer) async {
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
            Navigator.of(context).pop(externalRef);
            return;
          }

          if (_attempt >= _maxAttempts) {
            _isChecking = false;
            _isExpired = true;
            timer.cancel();
          }

          if (mounted) {
            setState(() {});
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
      },
    );
  }

  Future<void> _openDeeplink() async {
    final link = widget.deeplink;

    if (link == null || link.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bakong deeplink not found')),
      );
      return;
    }

    setState(() {
      _isOpeningDeeplink = true;
    });

    try {
      final uri = Uri.parse(link);

      final canOpen = await canLaunchUrl(uri);
      if (!canOpen) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bakong app not installed. Please use the QR code below.'),
          ),
        );
        return;
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Bakong app')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open deeplink: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningDeeplink = false;
        });
      }
    }
  }

  Uint8List? _getSvgBytes() {
    try {
      if (widget.base64Image.trim().isEmpty) return null;
      final raw = widget.base64Image.contains(',')
          ? widget.base64Image.split(',').last
          : widget.base64Image;
      return base64Decode(raw);
    } catch (e) {
      debugPrint('Invalid QR base64: $e');
      return null;
    }
  }

  String? _getSvgString() {
    final bytes = _getSvgBytes();
    if (bytes == null) return null;
    try {
      return utf8.decode(bytes);
    } catch (e) {
      debugPrint('Invalid SVG string: $e');
      return null;
    }
  }

  Future<void> _shareQr(BuildContext shareContext) async {
    if (_isSharing) return;

    // Capture BEFORE any await
    final renderObject = shareContext.findRenderObject();
    final box = renderObject is RenderBox ? renderObject : null;

    setState(() {
      _isSharing = true;
    });

    try {
      final boundary =
      _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('QR widget not ready');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert QR to PNG');
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/payment_qr_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: 'Payment QR Code',
        sharePositionOrigin:
        box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share QR code: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _downloadQrToPhotos() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final boundary =
      _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('QR widget not ready');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert QR to PNG');
      }

      final result = await ImageGallerySaver.saveImage(
        byteData.buffer.asUint8List(),
        quality: 100,
        name: 'payment_qr_${DateTime.now().millisecondsSinceEpoch}',
      );

      final isSuccess = result['isSuccess'] == true || result['success'] == true;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSuccess
                ? 'QR saved to Photos successfully'
                : 'Failed to save QR to Photos',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save to Photos: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
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
    final svgString = _getSvgString();

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
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.isBakongOnly ? 'Bakong Payment' : 'KHQR Payment',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
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
                    if (svgString != null)
                      RepaintBoundary(
                        key: _qrKey,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: 490,
                            height: 490,
                            child: SvgPicture.string(
                              svgString,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('QR code is not available'),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // --- SHARE BUTTON (Secondary Action) ---
                        Expanded(
                          child: Builder(
                            builder: (buttonContext) {
                              return SizedBox(
                                height: 54, // Modern taller height
                                child: OutlinedButton(
                                  onPressed: _isSharing ? null : () => _shareQr(buttonContext),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    foregroundColor: Colors.black87,
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: _isSharing
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2.5),
                                  )
                                      : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.share_outlined, size: 20),
                                      SizedBox(width: 8),
                                      Text('Share',
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // --- SAVE TO PHOTOS BUTTON (Primary Action) ---
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isDownloading ? null : _downloadQrToPhotos,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor, // Or Colors.indigo / Color(0xFFE51D28)
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: _isDownloading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                                  : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.download_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text('Save Photo',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      _isExpired
                          ? 'QR expired'
                          : '$_countdownText | QR will be expired',
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    if (widget.deeplink != null && widget.deeplink!.isNotEmpty) ...[
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isExpired || _isOpeningDeeplink
                              ? null
                              : _openDeeplink,
                          child: _isOpeningDeeplink
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Pay via Bakong App'),
                        ),
                      ),
                    ],
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