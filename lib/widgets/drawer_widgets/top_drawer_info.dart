import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TopDrawerInfo extends StatelessWidget {
  const TopDrawerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        child: Lottie.network(
          'https://lottie.host/69eaa217-49ab-48eb-aea9-e9f2329934f7/p5OOnpzQYD.json',
          width: 50,
          height: 50,
          repeat: true,
        ),
      ),
      title: Text('PokeApp', style: TextStyle(color: Colors.white)),
    );
  }
}
