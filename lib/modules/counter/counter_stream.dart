import 'dart:async';

class CounterStream {
  final _counterController = StreamController<int>();

  Stream<int> get counterStream => _counterController.stream;

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    _counterController.sink.add(_counter);
  }

  void dispose() {
    _counterController.close();
  }
}
