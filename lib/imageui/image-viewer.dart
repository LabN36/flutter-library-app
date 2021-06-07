import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'image-thumbnail.dart';

class ImageViewer extends StatefulWidget {
  ImageViewer({
    this.loadingBuilder,
    this.backgroundDecoration,
//     this.minScale,
//     this.maxScale,
    this.initialIndex = 0,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final BoxDecoration backgroundDecoration;
//   final dynamic minScale;
//   final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<ImageItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _ImageViewerState();
  }
}

class _ImageViewerState extends State<ImageViewer> {
  int currentIndex = 0; //widget.initialIndex;
  // this.initial

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
//             Container(
//               padding: const EdgeInsets.all(20.0),
//               child: Text(
//                 "Image ${currentIndex + 1}",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 17.0,
//                   decoration: null,
//                 ),
//               ),
            // )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final ImageItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: item.isLocal
          ? FileImage(File(item.resource))
          : CachedNetworkImageProvider(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}
