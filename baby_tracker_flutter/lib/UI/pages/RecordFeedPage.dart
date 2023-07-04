import 'package:baby_tracker_flutter/Entity/BabyEventChangeNotifier.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/DateTimeSelector.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../Entity/Feed.dart';
import '../common_widgets/DurationTimer.dart';

class RecordFeedPage extends StatefulWidget {
  const RecordFeedPage({super.key});

  @override
  State<RecordFeedPage> createState() => _RecordFeedPageState();
}

class _RecordFeedPageState extends State<RecordFeedPage> {
  final Color feedColour = const Color(0xFFa71a40);

  final CollectionReference babyEventCollection = FirebaseFirestore.instance.collection("babyEvents");

  // State
  String _startDate = "";
  String _startTime = "";
  int _durationHours = 0;
  int _durationMinutes = 0;
  int _durationSeconds = 0;
  String _feedType = "Left Side";
  String saveBtnLbl = "Save Feed";

  // Controllers
  var inputHoursController = TextEditingController();
  var inputMinutesController = TextEditingController();
  var inputSecondsController = TextEditingController();
  var inputNoteController = TextEditingController();

  // Handler for Start Time Widget
  void onDateTimeSelectorStateChange(String date, String time) {
    _startDate = date;
    _startTime = time;
  }

  // Handler for duration timer
  void onDurationTimerStateChange(int hours, int minutes, int seconds) {
    _durationHours = hours;
    _durationMinutes = minutes;
    _durationSeconds = seconds;
  }

  void submitFeed(BabyEventChangeNotifier babyEventChangeNotifier) {
    String startDate = _startDate;
    String startTime = _startTime;
    String duration = '$_durationHours,$_durationMinutes,$_durationSeconds';
    String feedType = _feedType;
    String note = inputNoteController.text;
    Feed newFeed = Feed(
        startDate: startDate,
        startTime: startTime,
        duration: duration,
        feedType: feedType,
        note: note);
    setState(() {
      saveBtnLbl = "Saving...";
    });

    //await babyEventCollection.add(newFeed.toJson());
    babyEventChangeNotifier.add(newFeed, onSuccessfulSave);
  }

  void onSuccessfulSave() {
    resetState();
    _showToast("Feed successfully recorded");
  }

  void resetState() {
    setState(() {
      _startDate = "";
      _startTime = "";
      saveBtnLbl = "Save Feed";
      inputNoteController.text = "";
    });
  }

  void _showToast(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Feed successfully recorded!"),
            content: Image.asset("assets/feed.gif"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "ok",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BabyEventChangeNotifier>(builder: buildFeedPage);
  }

  Widget buildFeedPage(BuildContext context,
      BabyEventChangeNotifier babyEventChangeNotifier, _) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: HighlightedText(
                    label: "Start Time 🕒️", colour: feedColour),
              ),
              DateTimeSelector(onStateChange: onDateTimeSelectorStateChange),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                child:
                    HighlightedText(label: "Duration ⏰️️", colour: feedColour),
              ),
              DurationTimer(onStateChanged: onDurationTimerStateChange),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                child:
                    HighlightedText(label: "Feed Type 🤱", colour: feedColour),
              ),
              DropdownButton<String>(
                value: _feedType,
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _feedType = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                      value: "Right Side", child: Text("Right Side 👉")),
                  DropdownMenuItem(
                      value: "Left Side", child: Text("Left Side 👈")),
                  DropdownMenuItem(
                      value: "Both Sides", child: Text("Both Sides 🙌")),
                  DropdownMenuItem(value: "Bottle", child: Text("Bottle 🍼"))
                ],
              ),
              TextField(
                  decoration: const InputDecoration(
                    label: Text("Note 📝"),
                    hintText: "Write note here",
                  ),
                  controller: inputNoteController),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton.icon(
                    onPressed: () {
                      submitFeed(babyEventChangeNotifier);
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    label: Text(
                      saveBtnLbl,
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
