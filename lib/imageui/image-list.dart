import 'package:flutter/material.dart';
import 'image-thumbnail.dart';
import 'image-viewer.dart';

class ImageList extends StatefulWidget {
  ImageList({@required this.imageItemsList});

  final List<ImageItem> imageItemsList;
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imageItemsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ImageThumbnail(
            galleryExampleItem: widget.imageItemsList[index],
            onTap: () {
              print('[Tap]');
              open(context, index);
            },
          );
        });
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewer(
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(),
            ),
          ),
          galleryItems: widget.imageItemsList,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
