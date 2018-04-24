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

  void _getQuotes() {
    // Get the quotes from our json file and put it into quotesList.
    rootBundle.loadString('assets/json/quotes.json').then((String fileData){
      setState(() {
        quotesList = json.decode(fileData);
      });
    });
  }

  @override
  void initState() {
    _getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: // While the quotes are being loaded, display a progress indicator.
        (quotesList!=null) ?
          _buildRandomQuoteWidget()
          : <Widget>[new CircularProgressIndicator()],
    );
  }

  List<Widget> _buildRandomQuoteWidget(){
    // get a random number that will be used to get a quote from the list.
    final random = new Random();
    int randomQuoteIndex = random.nextInt(quotesList.length);
    // get the random quote and the corresponding author.
    final String quoteString = quotesList[randomQuoteIndex]["Quote String"];
    final String quoteAuthorNameString = quotesList[randomQuoteIndex]["Quote Author"];

    Container quoteTextContainer = new Container(
      alignment: Alignment.center,
      padding: new EdgeInsets.symmetric(vertical: 20.0),
      child: new Text(quoteString,
        style: new TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Container authorNameContainer = new Container(
      alignment: FractionalOffset.bottomRight,
      padding: new EdgeInsets.only(top: 5.0),
      child: new Text(('- $quoteAuthorNameString'),
        textAlign: TextAlign.end,
        style: new TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );

    return <Widget>[quoteTextContainer, authorNameContainer,];
  }

}
