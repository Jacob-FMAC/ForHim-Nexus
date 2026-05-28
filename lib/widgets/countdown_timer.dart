import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme_config.dart';
import '../providers/locale_provider.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;
  const CountdownTimer({super.key, required this.targetDate});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _duration = const Duration();

  @override
  void initState() {
    super.initState();
    _updateDuration();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateDuration());
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetDate != oldWidget.targetDate) {
      _updateDuration();
    }
  }

  void _updateDuration() {
    final now = DateTime.now();
    setState(() {
      _duration = widget.targetDate.difference(now);
      if (_duration.isNegative) _duration = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocaleProvider>(context).locale.languageCode;
    final isEn = lang == 'en';

    return Column(
      children: [
        Text(
          isEn ? 'COUNTDOWN TO DEADLINE' : '预约截止倒计时',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 10,
            letterSpacing: 3.5,
            color: ThemeConfig.neonCyan.withOpacity(0.45),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTimeBox(_duration.inDays.toString().padLeft(2, '0'), isEn ? 'DAYS' : '天'),
            _buildSeparator(),
            _buildTimeBox((_duration.inHours % 24).toString().padLeft(2, '0'), isEn ? 'HRS' : '时'),
            _buildSeparator(),
            _buildTimeBox((_duration.inMinutes % 60).toString().padLeft(2, '0'), isEn ? 'MIN' : '分'),
            _buildSeparator(),
            _buildTimeBox((_duration.inSeconds % 60).toString().padLeft(2, '0'), isEn ? 'SEC' : '秒'),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeConfig.neonCyan.withOpacity(0.35)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeConfig.neonCyan.withOpacity(0.1),
                ThemeConfig.neonCyan.withOpacity(0.03),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeConfig.neonCyan.withOpacity(0.18),
                blurRadius: 20,
              ),
              BoxShadow(
                color: ThemeConfig.neonCyan.withOpacity(0.06),
                blurRadius: 16,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Center hairline divider (flip-clock style)
              Positioned(
                top: 31,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  color: ThemeConfig.neonCyan.withOpacity(0.12),
                ),
              ),
              // Animated digit — slides out upward on change
              ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 1.0), // slide in from below
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ));
                    return SlideTransition(
                      position: offsetAnimation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Text(
                    value,
                    // Key forces AnimatedSwitcher to see a new widget on value change
                    key: ValueKey<String>(value),
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: ThemeConfig.neonCyan,
                      shadows: [
                        Shadow(
                          color: ThemeConfig.neonCyan.withOpacity(0.7),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 9,
            color: ThemeConfig.neonCyan.withOpacity(0.5),
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 28),
      child: _BlinkingColon(),
    );
  }
}

/// A colon that blinks every second to reinforce the ticking feel
class _BlinkingColon extends StatefulWidget {
  @override
  State<_BlinkingColon> createState() => _BlinkingColonState();
}

class _BlinkingColonState extends State<_BlinkingColon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.15, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 24,
          color: ThemeConfig.neonCyan.withOpacity(0.7),
          shadows: [
            Shadow(
              color: ThemeConfig.neonCyan.withOpacity(0.4),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
