import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCarousselPokemon extends StatelessWidget {
  const ImageCarousselPokemon({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma imagem de versão disponível.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white.withAlpha(180),
          ),
        ),
      );
    }

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.broken_image,
                  color: Colors.white.withAlpha(170),
                  size: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
