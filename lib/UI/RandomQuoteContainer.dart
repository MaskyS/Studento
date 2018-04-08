import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


class RandomQuoteContainer extends StatefulWidget {
  @override
  RandomQuoteContainerState createState() => new RandomQuoteContainerState();
}

class RandomQuoteContainerState extends State<RandomQuoteContainer> {

  List quotesList;
  int quotesListLength;

  getQuotes() async {
    var fileData = await rootBundle.loadString('assets/json/quotes.json');
    this.setState(() {
      quotesList = JSON.decode(fileData);
      quotesListLength = quotesList.length;
    });
  }

  @override
  void initState() {
    this.getQuotes();
  }

  @override
  Widget build(BuildContext context) {
  final _random = new Random();
  // get a random number which will be used to choose a quote from the list.
  int randomQuoteIndex = _random.nextInt(quotesListLength);

  final String quoteString = quotesList[randomQuoteIndex]["Quote String"];
  final String quoteAuthorNameString = quotesList[randomQuoteIndex]["Quote Author"];

  //The text Widget for the quote.
  final Container quoteText  = new Container(
    alignment: Alignment.center,
    padding: new EdgeInsets.symmetric(vertical: 20.0),
    child: new Text(quoteString,
      style: new TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18.0,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
  );

  // The text Widget for the author name.
  Container  quoteAuthorText = new Container(
    child: new Text(('- $quoteAuthorNameString'),
      textAlign: TextAlign.end,
      style: new TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    alignment: FractionalOffset.bottomRight,
    padding: new EdgeInsets.only(top: 5.0),
  );

  return new ListView(
    children: <Widget>[
      quoteText,
      quoteAuthorText,
    ],);
  }
}