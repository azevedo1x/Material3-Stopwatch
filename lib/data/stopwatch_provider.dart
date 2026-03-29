import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopwatchProvider = StateProvider<bool>((ref) => false);
final elapsedProvider = StateProvider<Duration>((ref) => Duration.zero);

final stopwatchServiceProvider = Provider<StopwatchService>((ref) {
  final service = StopwatchService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});

class StopwatchService {
  final Ref _ref;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  StopwatchService(this._ref);

  void start() {
    _stopwatch.start();
    _ref.read(stopwatchProvider.notifier).state = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _ref.read(elapsedProvider.notifier).state = _stopwatch.elapsed;
    });
  }

  void stop() {
    _stopwatch.stop();
    _ref.read(stopwatchProvider.notifier).state = false;
    _timer?.cancel();
    _timer = null;
    _ref.read(elapsedProvider.notifier).state = _stopwatch.elapsed;
  }

  void reset() {
    _stopwatch.reset();
    _ref.read(stopwatchProvider.notifier).state = false;
    _timer?.cancel();
    _timer = null;
    _ref.read(elapsedProvider.notifier).state = Duration.zero;
  }

  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
  }
}
