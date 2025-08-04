import 'package:flutter/material.dart';

/// Styling options for the [WaveFormBar].
class WaveFormBarStyle {
  /// Creates a [WaveFormBarStyle].
  ///
  /// [color] is the color of the bar. Defaults to cyan.
  /// [width] is the width of the bar. Defaults to 4.0.
  /// [margin] is the margin around the bar. Defaults to a horizontal margin of 2.
  const WaveFormBarStyle({
    this.color = Colors.cyan,
    this.width = 4.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 2),
  });

  /// The color of the bar.
  final Color color;

  /// The width of the bar.
  final double width;

  /// The margin around the bar.
  final EdgeInsetsGeometry margin;
}
