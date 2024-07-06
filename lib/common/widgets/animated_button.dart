import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    Key? key,
    required this.onTap,
    required this.child,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget child;
  final String text;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  double _buttonScale = 1;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buttonScale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: (_) => _startAnimation(),
      onTapUp: (_) {
        _reverseAnimation();
        widget.onTap.call();
      },
      onTapCancel: () => _reverseAnimation(),
      child: Transform.scale(
        scale: _buttonScale,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            border: Border.all(width: 2, color: const Color(0xFFF748A4)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 4),
                blurRadius: 12.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: widget.child,
              ),
              Text(
                widget.text,
                style: const TextStyle(fontFamily: "Wonder"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _startAnimation() {
    _controller.forward();
  }

  void _reverseAnimation() {
    _controller.reverse();
  }
}
