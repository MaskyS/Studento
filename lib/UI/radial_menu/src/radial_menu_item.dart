import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _defaultButtonSize = 48.0;

/// An item in a [RadialMenu].
///
/// The type `T` is the type of the value the entry represents. All the entries
/// in a given menu must represent values with consistent types.
class RadialMenuItem<T> extends StatelessWidget {
  /// Creates a circular action button for an item in a [RadialMenu].
  ///
  /// The [child] argument is required.
  const RadialMenuItem({
    Key key,
    @required this.buttonText,
    this.value,
    this.tooltip,
    this.size = _defaultButtonSize,
  })  : assert(buttonText != null),
        assert(size != null),
        super(key: key);

  /// The string for the [Text] Widget inside the circle button.
  final String buttonText;

  /// The value to return if the user selects this menu item.
  ///
  /// Eventually returned in a call to [RadialMenu.onSelected].
  final T value;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String tooltip;

  /// The size of the button.
  ///
  /// Defaults to 48.0.
  final double size;

  @override
  Widget build(BuildContext context) {

    Widget result;

    if (buttonText != null) {
      // If [buttonText] is more than 1 word, split into two lines so the text
      // doesn't overflow the button.
      buttonText.replaceFirst(" ", " \n");
      buttonText.toUpperCase(); // Prettify by converting to uppercase.

      result = new Center(
        child: new Text(
          buttonText,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: Colors.black87,
            fontSize: 9.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    if (tooltip != null) {
      result = new Tooltip(
        message: tooltip,
        child: result,
      );
    }

    result = new Container(
      decoration: new ShapeDecoration(
        shape: new CircleBorder(side: new BorderSide(color: Colors.blue[700]),),
        color: Colors.white,
      ),
      width: size,
      height: size,
      child: result,
    );

    return result;
  }
}
