import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:poke_app_arc/core/consts/app_colors.dart';
import 'package:poke_app_arc/widgets/drawer_widgets/diglett_tile.dart';
import 'package:poke_app_arc/widgets/drawer_widgets/title_text_item.dart';
import 'package:poke_app_arc/widgets/drawer_widgets/top_drawer_info.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({super.key, required this.onSelectedPage});
  final void Function(int index) onSelectedPage;

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _diggletLottieController;
  bool _showDiglett = false;

  @override
  void initState() {
    super.initState();
    _diggletLottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _diggletLottieController.dispose();
  }

  void _onDiglettPressed() {
    setState(() {
      _showDiglett = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: AppColors.colorDarkBlue,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopDrawerInfo(),
                    SizedBox(height: 8),
                    Divider(color: Colors.white24),
                    SizedBox(height: 8),
                    ListTileItem(
                      'https://lottie.host/881d8a31-3f6c-431f-83bc-9406b336deca/tyPbnAkMAm.json',
                      titleTextItem: 'HOME',
                      isSelected: _selectedIndex == 0,
                      onTap: () {
                        _selectedIndex = 0;
                        widget.onSelectedPage(0);
                      },
                    ),
                    SizedBox(height: 8),
                    ListTileItem(
                      'https://lottie.host/6ffb5575-c5d1-4182-bcfe-69ee3e38bace/arrQb6XhMr.json',
                      titleTextItem: 'Procurar Pokemon',
                      isSelected: _selectedIndex == 1,
                      onTap: () {
                        _selectedIndex = 1;
                        widget.onSelectedPage(1);
                      },
                    ),
                    SizedBox(height: 8),
                    DiglettTile(onDiglettPressed: _onDiglettPressed),
                    SizedBox(height: 8),
                  ],
                ),
                if (_showDiglett)
                  Positioned(
                    bottom: 0,
                    child: Lottie.asset(
                      'assets/lotties/Diglett.json',
                      controller: _diggletLottieController,
                      repeat: false,
                      onLoaded: (composition) {
                        _diggletLottieController
                          ..duration = composition.duration
                          ..forward();

                        _diggletLottieController.addStatusListener((
                          status,
                        ) {
                          if (status == AnimationStatus.completed) {
                            setState(() {
                              _showDiglett = false;
                            });
                            _diggletLottieController.reset();
                          }
                        });
                      },
                      width: 350,
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
