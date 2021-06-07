import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class ImageItem {
  ImageItem(
      {@required this.id, @required this.resource, @required this.isLocal});

  final String id;
  final String resource;
  final bool isLocal;
}

class ImageThumbnail extends StatelessWidget {
  const ImageThumbnail({
    Key key,
    @required this.galleryExampleItem,
    @required this.onTap,
  }) : super(key: key);

  final ImageItem galleryExampleItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryExampleItem.id,
          // child: Image.network(galleryExampleItem.resource, height: 80.0),
          child: galleryExampleItem.isLocal
              ? Image.file(
                  File(galleryExampleItem.resource),
                  height: 80,
                )
              : Image(
                  image:
                      CachedNetworkImageProvider(galleryExampleItem.resource),
                  height: 80,
                ),
        ),
      ),
    );
  }
}
