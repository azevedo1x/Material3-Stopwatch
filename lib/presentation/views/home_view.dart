import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/stopwatch_provider.dart';
import 'about_view.dart';
import '../../widgets/AnimatedStopwatch.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOn = ref.watch(stopwatchProvider);
    final elapsed = ref.watch(elapsedProvider);
    final service = ref.watch(stopwatchServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stopwatch',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline_rounded, size: 22),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutView()),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(flex: 1),
              AnimatedStopwatch(elapsed: elapsed),
              const SizedBox(height: 32),
              TimerDisplay(elapsed: elapsed),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: ButtonRow(
                  isOn: isOn,
                  hasElapsed: elapsed > Duration.zero,
                  onStartPause: () {
                    if (isOn) {
                      service.stop();
                    } else {
                      service.start();
                    }
                  },
                  onReset: () => service.reset(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerDisplay extends StatelessWidget {
  final Duration elapsed;

  const TimerDisplay({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final millis = (elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');

    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$hours:$minutes:$seconds',
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w300,
            fontFamily: 'monospace',
            letterSpacing: 2,
          ),
        ),
        Text(
          '.$millis',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
            fontFamily: 'monospace',
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  final bool isOn;
  final bool hasElapsed;
  final VoidCallback onStartPause;
  final VoidCallback onReset;

  const ButtonRow({
    super.key,
    required this.isOn,
    required this.hasElapsed,
    required this.onStartPause,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 72,
              height: 72,
              child: AnimatedOpacity(
                opacity: hasElapsed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FilledButton.tonal(
                  onPressed: hasElapsed ? onReset : null,
                  style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.refresh_rounded, size: 28),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 88,
            height: 88,
            child: FilledButton(
              onPressed: onStartPause,
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                backgroundColor: isOn
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              child: Icon(
                isOn ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 40,
                color: isOn
                    ? theme.colorScheme.onError
                    : theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
