import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/server_url.dart';

class FullScreenImage extends StatelessWidget {
  final int imageId;
  final String encryptionKey;
  const FullScreenImage(
      {required this.imageId, required this.encryptionKey, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent, actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: IconButton(
                onPressed: () {
                  launch(
                      '$baseServerUrl/image/$imageId/$encryptionKey/download/');
                },
                icon: const Icon(
                  Icons.download_rounded,
                  size: 30,
                )),
          )
        ]),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(
                '$baseServerUrl/image/$imageId/$encryptionKey',
              ),
              alignment: Alignment.center,
            ),
          ),
        ));
  }
}
