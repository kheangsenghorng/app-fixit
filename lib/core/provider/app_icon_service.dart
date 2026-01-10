import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppIconService {
  static bool _isChanging = false;

  static Future<void> changeAppIcon(String iconName) async {
    if (_isChanging) return;
    _isChanging = true;

    try {
      if (!await FlutterDynamicIcon.supportsAlternateIcons) return;

      // Current icon: returns null if it's the Primary icon
      String? currentIcon = await FlutterDynamicIcon.getAlternateIconName();

      // If user wants 'Modern', target is null (Primary)
      String? targetIcon = (iconName == "Classic" || iconName == "Lifestyle") ? null : iconName;

      if (currentIcon == targetIcon) {
        debugPrint('Icon is already set to $iconName');
        return;
      }

      // Small delay prevents UI threading issues (Code 35)
      await Future.delayed(const Duration(milliseconds: 500));

      await FlutterDynamicIcon.setAlternateIconName(targetIcon);

    } on PlatformException catch (e) {
      debugPrint('Platform error changing icon: ${e.message}');
    } catch (e) {
      debugPrint('Failed to change app icon: $e');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      _isChanging = false;
    }
  }
}