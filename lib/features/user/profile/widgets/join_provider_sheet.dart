import 'dart:ui'; // REQUIRED for ImageFilter
import 'package:flutter/material.dart';

class JoinProviderSheet extends StatelessWidget {
  const JoinProviderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // THEME COLORS (Matches your Profile UI)
    final contentColor = isDark ? Colors.white : Colors.black;
    final glassColor = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8) 
        : Colors.white.withValues(alpha: 0.9);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.only(
            left: 24, 
            right: 24, 
            top: 12, 
            bottom: MediaQuery.of(context).padding.bottom + 20
          ),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. DRAG HANDLE
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: contentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 40),

              // 2. ICON (Branding Blue)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_rounded, 
                  size: 50, 
                  color: theme.colorScheme.primary
                ),
              ),
              const SizedBox(height: 24),

              // 3. TITLE (Monochrome)
              Text(
                "Become a Provider",
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),

              // 4. DESCRIPTION
              Text(
                "Start earning money by offering your services to customers in your area. Join our community today!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: contentColor.withValues(alpha: 0.5),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // 5. PRIMARY BUTTON (Stadium/Pill Shape)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/register-provider');
                  },
                  child: const Text(
                    "Get Started", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 6. SECONDARY BUTTON (Text Only)
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: contentColor.withValues(alpha: 0.4),
                ),
                child: const Text(
                  "Maybe Later", 
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}