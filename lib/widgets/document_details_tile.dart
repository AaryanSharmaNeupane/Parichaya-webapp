import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/full_screen_image.dart';
import '../utils/string.dart';

// ignore: must_be_immutable
class SharedDocumentDetailsTiles extends StatefulWidget {
  List documents;
  String encryptionKey;
  SharedDocumentDetailsTiles({
    required this.documents,
    required this.encryptionKey,
    Key? key,
  }) : super(key: key);

  @override
  State<SharedDocumentDetailsTiles> createState() =>
      _SharedDocumentDetailsTilesState();
}

class _SharedDocumentDetailsTilesState
    extends State<SharedDocumentDetailsTiles> {
  List<int> expandedIndex = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ExpansionPanelList.radio(
              elevation: 0,
              animationDuration: const Duration(milliseconds: 500),
              children: widget.documents
                  .map(
                    (document) => ExpansionPanelRadio(
                      canTapOnHeader: true,
                      value: document['id'],
                      backgroundColor:
                          Theme.of(context).disabledColor.withOpacity(0.1),
                      headerBuilder: (context, isExpanded) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                generateLimitedLengthText(
                                    document['title'].toUpperCase(),
                                    MediaQuery.of(context).size.width < 800
                                        ? 20
                                        : 60),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    launch(
                                        'http://165.232.180.17:8080/api/share-link/document/${document['id']}/images/${widget.encryptionKey}/download/');
                                  },
                                  icon: const Icon(Icons.download_rounded))
                            ],
                          ),
                        );
                      },
                      body: Container(
                        margin: const EdgeInsets.all(10),
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          children: [
                            ...document['images'].map((image) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        'http://165.232.180.17:8080/api/share-link/image/${image['id']}/${widget.encryptionKey}',
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Material(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.3),
                                        child: InkWell(
                                          highlightColor:
                                              Colors.orange.withOpacity(0.1),
                                          splashColor: Colors.black12,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullScreenImage(
                                                        imageId: image['id'],
                                                        encryptionKey: widget
                                                            .encryptionKey,
                                                      )),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )),
    );
  }
}
