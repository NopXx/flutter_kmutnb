import 'package:flutter/material.dart';
import 'package:lab3/pages/about.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  late PhotoViewScaleStateController scaleStateController;

  void loadCounter() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    setState(() {
      _counter = perfs.getInt('counter') ?? 0;
    });
  }

  void _incrementCounter() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (perfs.getInt('counter') ?? 0) + 1;
      perfs.setInt('counter', _counter);
    });
  }

  void _decrementCounter() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (perfs.getInt('counter') ?? 0) - 1;
      perfs.setInt('counter', _counter);
    });
  }

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    loadCounter();
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  void goBack(){
    scaleStateController.scaleState = PhotoViewScaleState.originalSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(
          Icons.ac_unit_outlined,
          color: Colors.white,
        ),
        title: const Text('Lab 3'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              child: const Text('Next Page'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 10,
                    color: Colors.black12,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: Colors.black.withOpacity(0.8),
                            child: PhotoView(
                              imageProvider:
                                  const AssetImage('assets/images/food.png'),
                              scaleStateController: scaleStateController,
                            ),
                          );
                        },
                      );
                    },
                    child: const Image(
                      image: AssetImage('assets/images/food.png'),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  const Text(
                    'Food',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'decrementButton',
            backgroundColor: Colors.amber[200],
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(
            width: 8.0,
          ),
          FloatingActionButton(
            heroTag: 'incrementButton',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
