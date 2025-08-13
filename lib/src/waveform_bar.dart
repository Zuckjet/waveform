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
    this.maxHeight = 4,
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

    // 使用线性映射 + 对数缩放的组合方式
    if (amplitude.current <= -36) {
      // 环境噪音或静音，设置最小基线高度
      scaledAmplitude = 0.5; // 固定最小高度
    } else if (amplitude.current <= -30) {
      // 非常轻微的声音，略高于基线
      double normalizedValue = (amplitude.current + 50) / 10; // 0-1之间
      scaledAmplitude = 0.5 + normalizedValue * 0.8; // 0.5-1.3
    } else if (amplitude.current <= -20) {
      // 小声说话，明显增加
      double normalizedValue = (amplitude.current + 40) / 10; // 0-1之间
      scaledAmplitude = 1.3 + normalizedValue * 1.5; // 1.3-2.8
    } else if (amplitude.current <= -10) {
      // 正常说话，显著高度
      double normalizedValue = (amplitude.current + 30) / 10; // 0-1之间
      scaledAmplitude = 2.8 + normalizedValue * 2.2; // 2.8-5.0
    } else {
      // 大声说话或音乐，最大高度
      double normalizedValue =
          math.min((amplitude.current + 20) / 20, 1.0); // 限制在0-1
      scaledAmplitude = 5.0 + normalizedValue * 3.0; // 5.0-8.0
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
