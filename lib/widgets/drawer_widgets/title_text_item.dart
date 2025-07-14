import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ListTileItem extends StatefulWidget {
  final String urlLottie;
  final String titleTextItem;
  final bool isSelected;
  final VoidCallback? onTap;

  const ListTileItem(
    this.urlLottie, {
    super.key,
    required this.titleTextItem,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<ListTileItem> createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLoadedLottie(LottieComposition composition) {
    _controller.duration = composition.duration;
  }

  void _playLottieAnimation() {
    _controller.forward(from: 0.0); // Inicia do inicio
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          left: 0,
          right: widget.isSelected ? 0 : 288,
          top: 0,
          bottom: 0,
          child: Container(
            decoration: widget.isSelected
                ? BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
          ),
        ),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          leading: SizedBox(
            height: 34,
            width: 34,

            // ==> Para lotties na Assets
            // child: Lottie.asset(
            //   widget.urlLottie,
            //   repeat: false,
            //   onLoaded: _onLoadedLottie,
            //   controller: _controller,
            // ),

            // ==> Lottie em Net
            child: Lottie.network(
              widget.urlLottie,
              repeat: false,
              onLoaded: _onLoadedLottie,
              controller: _controller,
            ),
          ),
          title: Text(
            widget.titleTextItem,
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            _playLottieAnimation();
            widget.onTap?.call();
          },
        ),
      ],
    );
  }
}
