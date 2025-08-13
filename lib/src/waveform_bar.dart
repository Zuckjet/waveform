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
    double amplitudeValue = amplitude.current.abs().clamp(1, 160.0);
    // 根据不同的音频强度调整缩放
    double scaledAmplitude;

    if (amplitude.current <= -50) {
      // 环境噪音或静音（-50dB及以下），高度降为原来的1/3
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.8) * 1.5;
    } else if (amplitude.current <= -40) {
      // 非常轻微的声音（-40到-50dB），稍微增加
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.7) * 2.5;
    } else if (amplitude.current <= -30) {
      // 小声说话（-30到-40dB），适中高度
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.6) * 4;
    } else if (amplitude.current <= -20) {
      // 正常说话（-20到-30dB），正常高度
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.5) * 5;
    } else {
      // 大声说话或音乐（-20dB以上），最大高度
      scaledAmplitude = math.pow(160.0 / amplitudeValue, 0.4) * 6;
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
