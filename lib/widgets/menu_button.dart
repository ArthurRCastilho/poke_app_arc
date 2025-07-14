import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    super.key,
    required this.onPress,
    required this.isDrawerClosed,
  });

  final VoidCallback onPress;
  final bool isDrawerClosed;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;

  final double _animationSpeedFactor = 0.5; // 2x mais rápido

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: Duration.zero,
    );

    // Opcional: Adicionar um listener se precisar de ações específicas ao completar/reverter
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !widget.isDrawerClosed) {
        // Se a animação chegou ao fim (0.5) e o drawer deveria estar aberto (X)
        // Isso é para garantir que ele finalize no X
        _lottieController.value = 0.5;
      } else if (status == AnimationStatus.dismissed &&
          widget.isDrawerClosed) {
        // Se a animação chegou ao início (0.0) e o drawer deveria estar fechado (Menu)
        // Isso é para garantir que ele finalize no Menu
        _lottieController.value = 0.0;
      }
    });
  }

  @override
  void didUpdateWidget(covariant MenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Este método é chamado quando os parâmetros do widget mudam.
    // Usaremos para garantir que a animação do Lottie reflita o estado do drawer.
    if (widget.isDrawerClosed != oldWidget.isDrawerClosed) {
      if (widget.isDrawerClosed) {
        // Se o drawer está fechando, a animação do botão deve ir para o início (ícone de menu)
        // Anima para 0.0 (início) do valor atual do controlador
        _lottieController.animateTo(
          0.0,
          duration:
              _lottieController.duration! *
              (_lottieController.value /
                  0.5), // Ajusta a duração baseada na distância para 0.0
          curve: Curves.fastOutSlowIn,
        );
      } else {
        // Se o drawer está abrindo, a animação do botão deve ir para a metade (X)
        // Anima para 0.5 (metade) do valor atual do controlador
        _lottieController.animateTo(
          0.5,
          duration:
              _lottieController.duration! *
              ((0.5 - _lottieController.value) /
                  0.5), // Ajusta a duração baseada na distância para 0.5
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _onLottieLoaded(LottieComposition composition) {
    _lottieController.duration =
        composition.duration * _animationSpeedFactor;
    // Defina o estado inicial da animação Lottie com base no estado inicial do drawer
    if (!widget.isDrawerClosed) {
      // Se o drawer começa aberto, o botão deve ser um 'X'
      _lottieController.value = 0.5;
    } else {
      // Se o drawer começa fechado, o botão deve ser um 'Menu'
      _lottieController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          widget.onPress.call();
        },
        child: Container(
          margin: EdgeInsets.only(left: 16),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.red.shade800,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 10,
              ),
            ],
          ),
          child: Lottie.network(
            'https://lottie.host/191b153e-7021-496f-94ac-e65368f81540/hTDECwlEdq.json',
            controller: _lottieController,
            onLoaded: _onLottieLoaded,
            repeat: false,
            animate: false, // Animação não inicia automático
          ),
        ),
      ),
    );
  }
}
