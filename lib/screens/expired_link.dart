import 'package:flutter/material.dart';

class ExpiredLinkView extends StatelessWidget {
  const ExpiredLinkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(1),
              Colors.blue.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.all(50)
            : const EdgeInsets.all(15),
        child: Card(
          elevation: 15,
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 100),
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
                  'Sorry we couldn’t find any files to share.',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Please check if your share link is valid and try again.',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
