import 'package:flutter/material.dart';
import '../screens/homepage.dart';
import '../screens/share_link_details.dart';
import './screens/expired_link.dart';
import './screens/share_link_details.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Parichaya - A Document Storage and Sharing App.',
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        debugShowCheckedModeBanner: false,
      );

  final _router = GoRouter(
    errorBuilder: (context, state) => const ExpiredLinkView(),
    routes: [
      GoRoute(
        path: '/:shareLinkId/:encryptionKey',
        builder: (context, state) {
          return ShareLinkDetails(
            shareLinkId: state.params['shareLinkId']!,
            encryptionKey: state.params['encryptionKey']!,
          );
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/expired',
        builder: (context, state) {
          return const ExpiredLinkView();
        },
      ),
    ],
  );
}
