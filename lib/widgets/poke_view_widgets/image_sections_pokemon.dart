import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageSectionsPokemon extends StatelessWidget {
  const ImageSectionsPokemon({
    super.key,
    required this.title,
    required this.imageUrls,
  });
  final String title;
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: imageUrls.map((url) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
