import 'package:flutter/material.dart';

class DiglettTile extends StatefulWidget {
  const DiglettTile({super.key, required this.onDiglettPressed});

  final VoidCallback onDiglettPressed;

  @override
  State<DiglettTile> createState() => _DiglettTileState();
}

class _DiglettTileState extends State<DiglettTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isAnimating
          ? null
          : () {
              setState(() {
                _isAnimating = true;
              });
              _animationController.forward();
              widget.onDiglettPressed();
            },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _isAnimating ? 0.6 : 1.0,
            child: ListTile(
              leading: Image.asset(
                'assets/icons/diglett.png',
                width: 32,
                height: 32,
              ),
              title: Text(
                'Diglett',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
