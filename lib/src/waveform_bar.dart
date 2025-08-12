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
    double amplitudeValue = amplitude.current.abs().clamp(0.1, 160.0);
    // 根据不同的音频强度调整缩放
    double scaledAmplitude;

    if (amplitude.current >= -40) {
      // 不说话的时候（-40及以上），减少3倍左右
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.7) * 2;
    } else if (amplitude.current >= -30) {
      // 小声说话的时候（-30到-40之间），适当增加1/2
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.7) * 8;
    } else {
      // 正常或大声说话，使用原来的缩放
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.7) * 6;
    }

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
