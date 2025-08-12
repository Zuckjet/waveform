import 'package:flutter/material.dart';

import 'amplitude.dart';
import 'waveform_bar_style.dart';
import 'dart:math' as math;

/// A widget that represents a single bar in a waveform visualisation.
///
/// The height of the bar is determined by the provided [amplitude], and
/// the bar can optionally be animated with a provided [animation].
class WaveFormBar extends StatelessWidget {
  /// Creates a [WaveFormBar] widget.
  ///
  /// [amplitude] is the amplitude value that determines the height of the bar.
  /// [animation] is an optional animation for the bar.
  /// [maxHeight] is the maximum height multiplier for the bar. Defaults to 2.
  /// [style] is the styling for the bar.
  const WaveFormBar({
    super.key,
    required this.amplitude,
    this.animation,
    this.maxHeight = 2,
    this.style = const WaveFormBarStyle(),
  });

  final Amplitude amplitude; // The amplitude value for the bar height.
  final Animation<double>? animation; // Optional animation for the bar.
  final int maxHeight; // Maximum height multiplier for the bar.
  final WaveFormBarStyle style; // Styling for the bar.

  /// Builds the waveform bar widget.
  ///
  /// The height of the bar is calculated based on the amplitude value,
  /// constrained to a range between 1 and 160, and multiplied by [maxHeight].
  Widget _buildWaveFormBar() {
    // 解决方案2: 简单的幂函数缩放
    double amplitudeValue = amplitude.current.abs().clamp(0.1, 160.0);

    // 使用幂函数提高敏感度，指数越小对小值越敏感
    double scaledAmplitude = math.pow(amplitudeValue / 160.0, 0.7) * 100;

    return Container(
      width: style.width,
      height: scaledAmplitude * maxHeight,
      decoration: BoxDecoration(
        color: style.color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: style.margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If an animation is provided, wrap the waveform bar in a SizeTransition.
    if (animation != null) {
      return SizeTransition(sizeFactor: animation!, child: _buildWaveFormBar());
    } else {
      // Otherwise, return the waveform bar without animation.
      return _buildWaveFormBar();
    }
  }
}
