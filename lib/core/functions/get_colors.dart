// TODO: FAZER função para pegar cores

  import 'package:flutter/material.dart';

Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Colors.lightGreen.shade700;
      case 'fire':
        return Colors.deepOrange.shade700;
      case 'water':
        return Colors.blue.shade700;
      case 'bug':
        return Colors.lightGreen.shade500;
      case 'normal':
        return Colors.grey.shade600;
      case 'poison':
        return Colors.purple.shade700;
      case 'electric':
        return Colors.amber.shade700;
      case 'ground':
        return Colors.brown.shade700;
      case 'fairy':
        return Colors.pinkAccent.shade100;
      case 'fighting':
        return Colors.red.shade700;
      case 'psychic':
        return Colors.purpleAccent.shade400;
      case 'rock':
        return Colors.brown.shade400;
      case 'ghost':
        return Colors.indigo.shade700;
      case 'ice':
        return Colors.lightBlue.shade300;
      case 'dragon':
        return Colors.indigo.shade900;
      case 'steel':
        return Colors.blueGrey.shade700;
      case 'dark':
        return Colors.black87;
      case 'flying':
        return Colors.lightBlue.shade400;
      default:
        return Colors.grey.shade400;
    }
  }