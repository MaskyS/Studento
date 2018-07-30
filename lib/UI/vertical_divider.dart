import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({
    Key key,
    this.width: 16.0,
    this.indent: 0.0,
    this.color
  }) : assert(width >= 0.0),
       super(key: key);

  /// The divider's horizontal extent.
  ///
  /// The divider itself is always drawn as one device pixel thick vertical
  /// line that is centered within the height specified by this value.
  ///
  /// A divider with a width of 0.0 is always drawn as a line with a width of
  /// exactly one device pixel, without any padding around it.
  final double width;

  /// The amount of empty space to the right of the divider.
  final double indent;

  /// The color to use when painting the line.
  ///
  /// Defaults to the current theme's divider color, given by
  /// [ThemeData.dividerColor].
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// Divider(
  ///   color: Colors.deepOrange,
  /// )
  /// ```
  final Color color;

  @override
  Widget build(BuildContext context) => RotatedBox(
    quarterTurns: 1,
    child: Divider(
      key: key,
      color: color,
      height: width,
      indent: indent,
    ),
  );
}