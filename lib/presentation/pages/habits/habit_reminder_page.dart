import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_strings.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/core/services/notification_service.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/presentation/providers/habit_provider.dart';
import 'package:just_audio/just_audio.dart';
const String _kReminderRingtoneAsset = 'assets/sounds/soar_binaural_beat.mp3';

class HabitReminderPage extends ConsumerStatefulWidget {
  final String habitId;
  final String? reminderSlotKey;
  /// When the app cold-starts from a notification, Riverpod may not have habits yet; this renders immediately.
  final HabitEntity? initialHabit;

  const HabitReminderPage({
    super.key,
    required this.habitId,
    this.reminderSlotKey,
    this.initialHabit,
  });

  @override
  ConsumerState<HabitReminderPage> createState() => _HabitReminderPageState();
}

class _HabitReminderPageState extends ConsumerState<HabitReminderPage> {
  final AudioPlayer _ringtonePlayer = AudioPlayer();
  Timer? _ringtoneStopTimer;
  bool _ringtoneStoppedByUser = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    HapticFeedback.heavyImpact();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(_HabitReminderPageState.kRingtoneStartDelay, () {
        if (mounted && !_ringtoneStoppedByUser) _startRingtone();
      });
    });
  }

  static Duration get kRingtoneStartDelay =>
      Duration(milliseconds: AppValues.reminderRingtoneStartDelayMs);

  Future<void> _startRingtone() async {
    if (!mounted || _ringtoneStoppedByUser) return;
    try {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.alarm,
          flags: AndroidAudioFlags.none,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      ));
      if (_ringtoneStoppedByUser || !mounted) return;
      await _ringtonePlayer.setAsset(_kReminderRingtoneAsset);
      await _ringtonePlayer.setLoopMode(LoopMode.one);
      await _ringtonePlayer.play();
      if (!mounted || _ringtoneStoppedByUser) return;
      _ringtoneStopTimer = Timer(
        Duration(minutes: AppValues.reminderRingtoneMaxDurationMinutes),
        () {
          _ringtoneStopTimer?.cancel();
          _ringtoneStopTimer = null;
          _ringtonePlayer.stop();
        },
      );
    } catch (e) {
      debugPrint('HabitReminderPage: failed to play ringtone: $e');
      if (mounted && !_ringtoneStoppedByUser) {
        Future.delayed(
          Duration(milliseconds: AppValues.reminderRingtoneRetryDelayMs),
          () {
          if (mounted && !_ringtoneStoppedByUser) _startRingtoneRetry();
          });
      }
    }
  }

  Future<void> _startRingtoneRetry() async {
    if (!mounted || _ringtoneStoppedByUser) return;
    try {
      await _ringtonePlayer.setAsset(_kReminderRingtoneAsset);
      await _ringtonePlayer.setLoopMode(LoopMode.one);
      await _ringtonePlayer.play();
      if (!mounted || _ringtoneStoppedByUser) return;
      _ringtoneStopTimer = Timer(
        Duration(minutes: AppValues.reminderRingtoneMaxDurationMinutes),
        () {
          _ringtoneStopTimer?.cancel();
          _ringtoneStopTimer = null;
          _ringtonePlayer.stop();
        },
      );
    } catch (e) {
      debugPrint('HabitReminderPage: retry play ringtone failed: $e');
    }
  }

  Future<void> _stopRingtone() async {
    _ringtoneStoppedByUser = true;
    _ringtoneStopTimer?.cancel();
    _ringtoneStopTimer = null;
    try {
      await _ringtonePlayer.setVolume(0);
      await _ringtonePlayer.stop();
    } catch (_) {}
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _ringtoneStopTimer?.cancel();
    _ringtoneStopTimer = null;
    _ringtonePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitFromProvider = ref.watch(habitByIdProvider(widget.habitId));
    final habit = habitFromProvider ?? widget.initialHabit;

    if (habit == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(habit.color).withValues(alpha: AppDimensions.opacityHigh),
                      Color(habit.color),
                      Colors.black.withValues(alpha: AppDimensions.reminderGradientOverlayOpacity),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                _AnimatedIcon(icon: habit.icon, color: habit.color),
                SizedBox(height: AppDimensions.spacingXxxl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingLg,
                  ),
                  child: Text(
                    habit.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.reminderTitleFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: AppDimensions.letterSpacing,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.spacingXs),
                if (habit.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingXxxl,
                    ),
                    child: Text(
                      habit.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(
                          AppDimensions.reminderDescriptionOpacity,
                        ),
                        fontSize: AppDimensions.reminderDescriptionFontSize,
                      ),
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(
                    AppDimensions.reminderContentPadding,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.reminderButtonHeight,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _stopRingtone();
                            await NotificationService().cancelActiveNotificationForHabit(widget.habitId);
                            try {
                              if (widget.reminderSlotKey != null) {
                                await NotificationService().markReminderAcknowledged(widget.reminderSlotKey!);
                              }
                            } finally {
                              await NotificationService().scheduleHabitReminder(habit);
                              if (context.mounted) Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(habit.color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.reminderButtonBorderRadius,
                              ),
                            ),
                            elevation: AppDimensions.reminderButtonElevation,
                          ),
                          child: const Text(
                            AppStrings.reminderViewHabits,
                            style: TextStyle(
                              fontSize: AppDimensions.reminderDescriptionFontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: AppDimensions.letterSpacing,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingLg),
                      TextButton(
                        onPressed: () async {
                          await _stopRingtone();
                          await NotificationService().cancelActiveNotificationForHabit(widget.habitId);
                          try {
                            if (widget.reminderSlotKey != null) {
                              await NotificationService().markReminderAcknowledged(widget.reminderSlotKey!);
                            }
                          } finally {
                            await NotificationService().scheduleHabitReminder(habit);
                            if (context.mounted) Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Dismiss for now',
                          style: TextStyle(
                            color: Colors.white.withOpacity(
                              AppDimensions.reminderDismissTextOpacity,
                            ),
                            fontSize: AppDimensions.fontSizeXl,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedIcon extends StatefulWidget {
  final String icon;
  final int color;

  const _AnimatedIcon({required this.icon, required this.color});

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        seconds: AppDimensions.reminderPulseAnimationDurationSeconds,
      ),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: AppDimensions.reminderPulseScaleMin, end: AppDimensions.reminderPulseScaleMax).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.reminderIconContainerPadding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(AppDimensions.reminderIconBgOpacity),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(widget.color).withOpacity(
                AppDimensions.reminderIconShadowOpacity,
              ),
              blurRadius: AppDimensions.reminderIconShadowBlur,
              spreadRadius: AppDimensions.reminderIconShadowSpread,
            ),
          ],
        ),
        child: Icon(
          AppValues.getIconData(widget.icon),
          size: AppDimensions.reminderIconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
