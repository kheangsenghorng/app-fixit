import 'package:flutter/material.dart';

class AnimatedReloadButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isScrolling;
  const AnimatedReloadButton({super.key, required this.onTap, required this.isScrolling});

  @override
  State<AnimatedReloadButton> createState() => AnimatedReloadButtonState();
}

class AnimatedReloadButtonState extends State<AnimatedReloadButton> with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _bobController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _bobController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  void playSpinAnimation() => _spinController.forward(from: 0.0);

  @override
  void didUpdateWidget(AnimatedReloadButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScrolling && !oldWidget.isScrolling) _bobController.repeat(reverse: true);
    else if (!widget.isScrolling && oldWidget.isScrolling) _bobController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bobController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10 * _bobController.value),
          child: child,
        );
      },
      child: FloatingActionButton(
        heroTag: 'profile_reload_fab',
        backgroundColor: const Color(0xFF0056D2),
        onPressed: () { playSpinAnimation(); widget.onTap(); },
        child: RotationTransition(
          turns: _spinController,
          child: const Icon(Icons.refresh, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _bobController.dispose();
    super.dispose();
  }
}