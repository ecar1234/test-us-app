import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';

import '../../../services/common_height_provider.dart';


class PostImageDetailPage extends StatelessWidget {
  final List<ImageEntity> images;
  final int initialIndex;
  const PostImageDetailPage({super.key, required this.images, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: PageView.builder(
          controller: PageController(initialPage: initialIndex),
          itemCount: images.length,
          itemBuilder: (context, idx) {
            return InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: images[idx].url!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
