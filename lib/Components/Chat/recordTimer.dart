import 'dart:async';

class RecordTimer {
  Timer? _timer;
  final int duration;
  late int _remaining;
  final Function(int) timerStart;
  final Function() timerStop;

  RecordTimer({
    required this.timerStart,
    required this.timerStop,
    this.duration = 20,
  });

  void start() {
    _remaining = duration;
    timerStart(_remaining);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remaining == 0) {
        _timer?.cancel();
        timerStop();
      } else {
        _remaining--;
        timerStart(_remaining);
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
