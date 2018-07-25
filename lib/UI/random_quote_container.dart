import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    // While the quotes are being loaded, display a progress indicator.
    if (quotesList == null) {
      return CircularProgressIndicator();
    }

    return ListView(
      children: _buildRandomQuoteWidget(),
    );
  }

  List<Widget> _buildRandomQuoteWidget() {

    // Get a random quote and the corresponding author from the list.
    int randomIndex = Random().nextInt(quotesList.length);
    final String quoteString = quotesList[randomIndex]["Quote String"];
    final String quoteAuthorNameString =
        quotesList[randomIndex]["Quote Author"];

    Widget quoteTextContainer() => Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        quoteString,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    );

    Widget authorNameContainer() => Container(
      alignment: FractionalOffset.bottomRight,
      padding: EdgeInsets.only(top: 5.0),
      child: Text(
        ('- $quoteAuthorNameString'),
        textAlign: TextAlign.end,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );

    return <Widget>[
      quoteTextContainer(),
      authorNameContainer(),
    ];
  }
}
