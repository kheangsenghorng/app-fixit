import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../routes/app_routes.dart';

class ProviderCard extends StatefulWidget {
  final String name;
  final String job;
  final String imageUrl;
  final int typeId;
  final int currentIndex;

  const ProviderCard({
    super.key,
    required this.name,
    required this.job,
    required this.imageUrl,
    required this.typeId,
    required this.currentIndex,
  });

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  bool _isPressed = false;

  void _openDetails() {
    Navigator.pushNamed(
      context,
      AppRoutes.serviceCard,
      arguments: {
        'nameType': widget.name,
        'typeId': widget.typeId,
        'currentIndex': widget.currentIndex,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary;
    final contentColor = isDark ? Colors.white : Colors.black;

    final glassColor = isDark
        ? (_isPressed
        ? activeColor.withValues(alpha: 0.15)
        : const Color(0xFF1A1A1A).withValues(alpha: 0.7))
        : (_isPressed
        ? activeColor.withValues(alpha: 0.05)
        : Colors.white.withValues(alpha: 0.8));

    final borderColor = _isPressed
        ? activeColor.withValues(alpha: 0.4)
        : (isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05));

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _openDetails,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: glassColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: _isPressed
                    ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : activeColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Center(
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: activeColor.withValues(alpha: 0.5),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: contentColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.job,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: contentColor.withValues(alpha: 0.4),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _openDetails,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _isPressed
                            ? activeColor
                            : activeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          'Details',
                          style: TextStyle(
                            color: _isPressed ? Colors.white : activeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}