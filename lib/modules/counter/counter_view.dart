import 'package:flutter/material.dart';
import 'package:state_management/modules/counter/counter_stream.dart';

// Vista
class CounterView extends StatelessWidget {
  final CounterStream stream;

  const CounterView(this.stream, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        title: const Text("Contador StreamBuilder"),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: stream.counterStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Counter: ${snapshot.data}');
            } else {
              return const Text('Loading...');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            stream.incrementCounter();
          }),
    );
  }
}
