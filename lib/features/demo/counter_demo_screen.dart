import 'package:flutter/material.dart';

/// Default Flutter counter demo kept for reference; not used in the main app flow.
class CounterDemoScreen extends StatefulWidget {
  const CounterDemoScreen({super.key});

  @override
  State<CounterDemoScreen> createState() => _CounterDemoScreenState();
}

class _CounterDemoScreenState extends State<CounterDemoScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FacePix Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
