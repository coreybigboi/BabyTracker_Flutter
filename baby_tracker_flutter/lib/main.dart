import 'package:baby_tracker_flutter/Entity/BabyEventChangeNotifier.dart';
import 'package:baby_tracker_flutter/UI/pages/HistoryPage.dart';
import 'package:baby_tracker_flutter/UI/pages/HomePage.dart';
import 'package:baby_tracker_flutter/UI/pages/RecordNappyPage.dart';
import 'package:baby_tracker_flutter/UI/pages/RecordSleepPage.dart';
import 'package:baby_tracker_flutter/UI/pages/RecordFeedPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Entity/ProfileChangeNotifier.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("\n\nConnected to Firebase App ${app.options.projectId}\n\n");

  Provider.debugCheckInvalidValueType = null;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BabyEventChangeNotifier>(create: (context) => BabyEventChangeNotifier()),
        ChangeNotifierProvider<ProfileChangeNotifier>(create: (context) => ProfileChangeNotifier())
      ],
      child: MaterialApp(
        title: 'Baby Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Baby Tracker 👶'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex= 0; // navigation bar index

  // widgets for each nav bar item
  final tabs = [
    const HomePage(),
    const RecordFeedPage(),
    const RecordNappyPage(),
    const RecordSleepPage(),
    const HistoryPage(),
  ];

  // colours for each nav bar item
  final tabColours = [
    Colors.amber, // home colour
    Colors.redAccent, // feed colour
    Colors.blueAccent, // nappy colour
    Colors.purpleAccent, // sleep colour
    Colors.greenAccent // history colour
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tabColours[_currentIndex],
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: true,
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: "Home",
              backgroundColor: tabColours[_currentIndex]
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.water_drop),
              label: "Feed",
              backgroundColor: tabColours[_currentIndex]
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.baby_changing_station),
              label: "Nappy",
              backgroundColor: tabColours[_currentIndex]
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bedroom_baby),
              label: "Sleep",
              backgroundColor: tabColours[_currentIndex]
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: "History",
              backgroundColor: tabColours[_currentIndex]
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
