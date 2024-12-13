import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int count = 0;

  void incrementCounter() {
    if (count == 25) {
      return;
    }
    setState(() {
      count++;
    });
  }

  void decrementCounter() {
    if (count == -5) {
      return;
    }
    setState(() {
      count--;
    });
  }

  void resetCounter() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Hello 6606021421012'),
          centerTitle: false,
          leading: const Icon(
            Icons.home_max,
            size: 50,
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: null,
                      child: const Icon(
                        Icons.abc,
                        color: Colors.green,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Text('กดมาแล้ว (ครั้ง)'),
              const SizedBox(
                height: 8.0,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1.0,
                        blurRadius: 2.0,
                        offset: Offset(0.0, 3.0),
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Text(
                          count.toString(),
                          key: ValueKey<int>(count),
                          style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Icon(
                          Icons.arrow_circle_up_rounded,
                          key: ValueKey<int>(count),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Text(
                          '${count + 1 > 25 ? 'Max count' : count == -5 ? 'Min count' : count + 1}',
                          key: ValueKey<int>(count + 1),
                          style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 16.0,
          ),
          FloatingActionButton(
            onPressed: decrementCounter,
            tooltip: 'decrement',
            backgroundColor: Colors.red[300],
            child: const Icon(
              Icons.remove,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          FloatingActionButton(
            onPressed: resetCounter,
            tooltip: 'reset',
            backgroundColor: Colors.orange[300],
            child: const Icon(
              Icons.replay,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
