import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poke_app_arc/core/consts/app_colors.dart';
import 'package:poke_app_arc/screens/home_view.dart';
import 'package:poke_app_arc/screens/search_view.dart';
import 'package:poke_app_arc/widgets/drawer_widgets/drawer_component.dart';
import 'package:poke_app_arc/widgets/menu_button.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage>
    with SingleTickerProviderStateMixin {
  late bool isDrawerClosed = true;
  int _selectedIndex = 0;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;

  @override
  void initState() {
    _animationController =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 500),
        )..addListener(() {
          setState(() {});
        });

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSelectedPage(int index) async {
    await Future.delayed(Duration(milliseconds: 700));
    setState(() {
      _selectedIndex = index;
      isDrawerClosed = true;
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorDarkBlue,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isDrawerClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: DrawerComponent(onSelectedPage: _onSelectedPage),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 288, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: _selectedIndex == 0
                      ? const HomeView()
                      : const SearchView(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            top: 16,
            left: isDrawerClosed ? 0 : 220,
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: MenuButton(
              isDrawerClosed: isDrawerClosed,
              onPress: () {
                if (isDrawerClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                setState(() {
                  isDrawerClosed = !isDrawerClosed;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
