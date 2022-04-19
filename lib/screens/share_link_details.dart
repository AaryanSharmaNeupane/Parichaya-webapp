import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/expired_link.dart';
import '../utils/server_url.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/document_details_tile.dart';
import '../utils/date_formatter.dart';

class ShareLinkDetails extends StatefulWidget {
  final String shareLinkId;
  final String encryptionKey;

  const ShareLinkDetails(
      {required this.shareLinkId, required this.encryptionKey, Key? key})
      : super(key: key);

  @override
  State<ShareLinkDetails> createState() => _ShareLinkDetailsState();
}

class _ShareLinkDetailsState extends State<ShareLinkDetails> {
  // static const routeName = '/share_link_details';
  // bool _isLoading = true;
  bool _isFetchingDocuments = false;
  String _fetchingDocumentMessage = '';
  bool isInitialized = false;
  Map shareLinkData = {};
  String formattedExpiryDuration = '';

  Future<dynamic> getResponse(BuildContext context) async {
    setState(() {
      _isFetchingDocuments = true;
    });
    const baseUrl = baseServerUrl;
    final url = baseUrl + '/${widget.shareLinkId}/${widget.encryptionKey}/';
    setState(() {
      _fetchingDocumentMessage = 'Sending request for your documents...';
    });
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode != 200) {
        // GoRouter.of(context).go('/expired');
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ExpiredLinkView()));
      }
      setState(() {
        shareLinkData = json.decode(response.body);
        _isFetchingDocuments = false;
        final expiryDate = DateTime.parse(shareLinkData['expiry_date']);
        // final createdOn = DateTime.parse(shareLinkData['created_on']);
        formattedExpiryDuration = getFormattedExpiry(expiryDate);
        log(formattedExpiryDuration);
      });
    } catch (e) {
      // GoRouter.of(context).go('/expired');
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ExpiredLinkView()));
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getResponse();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      getResponse(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isFetchingDocuments
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(_fetchingDocumentMessage),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(1),
                    Colors.blue.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: MediaQuery.of(context).size.width > 800
                      ? const EdgeInsets.all(50)
                      : const EdgeInsets.all(15),
                  child: Card(
                    elevation: 15,
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fingerprint,
                                  size: 68,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Text(
                                  'Parichaya',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'We have some files for you.',
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            formattedExpiryDuration.isEmpty
                                ? 'Link Has Expired'
                                : 'Expires in $formattedExpiryDuration',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  launch(
                                      '$baseServerUrl/${shareLinkData['id']}/images/${widget.encryptionKey}/download/');
                                },
                                borderRadius: BorderRadius.circular(15),
                                splashColor: Colors.amber,
                                highlightColor: Colors.deepOrange,
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).primaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Download All Files',
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(color: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.download,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (shareLinkData.isNotEmpty)
                            SharedDocumentDetailsTiles(
                              documents: shareLinkData['documents'],
                              encryptionKey: widget.encryptionKey,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
