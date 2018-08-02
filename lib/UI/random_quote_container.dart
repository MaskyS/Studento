import 'dart:math';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'loading_page.dart';

class RandomQuoteContainer extends StatefulWidget {
  @override
  RandomQuoteContainerState createState() => RandomQuoteContainerState();
}

class RandomQuoteContainerState extends State<RandomQuoteContainer> {
  List quotesList;

  /// Read the quotes from the json file into [quotesList].
  void _getQuotes() {
    rootBundle.loadString('assets/json/quotes.json').then((String fileData) {
      setState(() =>
        quotesList = json.decode(fileData)
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getQuotes();
  }

  List<Widget> _buildRandomQuoteWidget() {

    // Get a random quote and the corresponding author from the list.
    int randomIndex = Random().nextInt(quotesList.length);
    final String quote = quotesList[randomIndex]["Quote String"];
    final String quoteAuthor =
        quotesList[randomIndex]["Quote Author"];

    const TextStyle quoteStyle = TextStyle(
      fontSize: 18.0,
      color: Colors.white,
    );

    const TextStyle quoteAuthorStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );

    Widget quoteTextContainer() => Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        quote,
        style: quoteStyle,
        textAlign: TextAlign.center,
      ),
    );

    Widget authorContainer() => Container(
      alignment: FractionalOffset.bottomRight,
      padding: EdgeInsets.only(top: 5.0),
      child: Text(
        ('- $quoteAuthor'),
        textAlign: TextAlign.end,
        style: quoteAuthorStyle,
      ),
    );

    return <Widget>[
      quoteTextContainer(),
      authorContainer(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // While the quotes are being loaded, display a progress indicator.
    if (quotesList == null) return loadingPage();

    return ListView(
      children: _buildRandomQuoteWidget(),
    );
  }
}
