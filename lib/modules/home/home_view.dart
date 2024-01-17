import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:state_management/modules/counter/counter_stream.dart';
import 'package:state_management/modules/counter/counter_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final stream =
      Stream<int>.periodic(const Duration(seconds: 1), (count) => count);

  final streamController2 = StreamController<String>();
  Faker faker = Faker();

  ValueNotifier<String> notified1 = ValueNotifier("");
  ValueNotifier<String> notified2 = ValueNotifier("");
  ValueNotifier<String> notified3 = ValueNotifier("");
  List<String> listName = [];
  late final subscriptionStream1;
  int stop = 10;

  Future convert(thing) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return thing; // async operation
  }

  @override
  void initState() {
    subscriptionStream1 = stream.listen((data) {
      if (data > stop) {
        subscriptionStream1.cancel();
      } else {
        notified1.value = data.toString();
      }
    }, onDone: () {});

    final stream2 = streamController2.stream;

    stream2.listen((data) {
      notified2.value = data;
    });

    streamController2.sink.add(faker.person.name());

    listName.addAll(generateRandomNamesList());
    final stream3 = Stream.fromIterable(listName)
        .asyncMap(convert)
        .where((value) => value != null);

    stream3.listen((data) async {
      notified3.value = data;
    });

    super.initState();
  }

  List<String> generateRandomNamesList({int count = 15}) {
    final faker = Faker();
    List<String> list = [];

    for (int i = 0; i < count; i++) {
      String randomName = faker.internet.userName();
      list.add(randomName);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Example Stream"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: IconButton(
                        onPressed: () {
                          subscriptionStream1.cancel();
                        },
                        icon: const Icon(Icons.back_hand_sharp)),
                    title: const Text("Subscripción Stream 1"),
                    subtitle: ValueListenableBuilder(
                      valueListenable: notified1,
                      builder:
                          (BuildContext context, String value, Widget? child) =>
                              Column(
                        children: [
                          Text(value),
                          if (value.isNotEmpty)
                            LinearProgressIndicator(
                              value: double.parse(value) / stop,
                              minHeight: 10.0,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue), //
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: IconButton(
                        onPressed: () {
                          streamController2.close();
                        },
                        icon: const Icon(Icons.back_hand_sharp)),
                    title: const Text("Subscripción Stream 2"),
                    subtitle: ValueListenableBuilder(
                      valueListenable: notified2,
                      builder:
                          (BuildContext context, String value, Widget? child) =>
                              Text(value),
                    ),
                    trailing: TextButton(
                      child: const Text("Cambiar Texto"),
                      onPressed: () {
                        streamController2.sink.add(faker.person.name());
                      },
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Subscripción Stream 3"),
                    subtitle: ValueListenableBuilder(
                      valueListenable: notified3,
                      builder:
                          (BuildContext context, String value, Widget? child) =>
                              Text(value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: const Text("Contador con Stream"),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return CounterView(CounterStream());
            }));
          },
        ),
      ),
    );
  }
}
