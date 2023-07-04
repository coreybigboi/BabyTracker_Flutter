import 'package:baby_tracker_flutter/Entity/BabyEventChangeNotifier.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/DateTimeSelector.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/DurationTimer.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../Entity/Sleep.dart';

class RecordSleepPage extends StatefulWidget {
  const RecordSleepPage({super.key});

  @override
  State<RecordSleepPage> createState() => _RecordSleepPageState();
}

class _RecordSleepPageState extends State<RecordSleepPage> {

  final Color sleepColour = Colors.purple;
  final CollectionReference babyEventCollection = FirebaseFirestore.instance.collection("babyEvents");

  // State
  String _startDate = "";
  String _startTime = "";
  int _durationHours = 0;
  int _durationMinutes = 0;
  int _durationSeconds = 0;
  String saveBtnLbl = "Save Sleep";

  // Controllers
  var inputHoursController = TextEditingController();
  var inputMinutesController = TextEditingController();
  var inputSecondsController = TextEditingController();
  var inputNoteController = TextEditingController();

  // Handler for Start Time Widget
  void onDateTimeSelectorStateChange(String date, String time){
    _startDate = date;
    _startTime = time;
  }

  // Handler for duration timer
  void onDurationTimerStateChange(int hours, int minutes, int seconds){
    _durationHours = hours;
    _durationMinutes = minutes;
    _durationSeconds = seconds;
  }

  void submitSleep(BabyEventChangeNotifier babyEventChangeNotifier) {
    String startDate = _startDate;
    String startTime = _startTime;
    String duration = '$_durationHours,$_durationMinutes,$_durationSeconds';
    String note = inputNoteController.text;
    Sleep newSleep = Sleep(
        startDate: startDate,
        startTime: startTime,
        duration: duration,
        note: note
    );
    setState(() {
      saveBtnLbl = "Saving...";
    });

    babyEventChangeNotifier.add(newSleep, onSuccessfulSave);
  }

  void onSuccessfulSave(){
    resetState();
    _showToast("Sleep successfully recorded");
  }

  void resetState(){
    setState(() {
      _startDate = "";
      _startTime = "";
      saveBtnLbl = "Save Sleep";
      inputNoteController.text = "";
    });
  }

  void _showToast(String message) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Sleep successfully recorded!"),
            content: Image.asset("assets/sleep.gif"),
            actions: [
              TextButton(
                onPressed: () { Navigator.pop(context); },
                child: const Text("ok", style: TextStyle(color: Colors.blue, fontSize: 20),),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BabyEventChangeNotifier>(builder: buildRecordSleepPage);
  }

  Widget buildRecordSleepPage(BuildContext context, BabyEventChangeNotifier babyEventChangeNotifier, _) {
    return Center(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HighlightedText(label: "Start Time 🕒️", colour: sleepColour),
          DateTimeSelector(onStateChange: onDateTimeSelectorStateChange),
          HighlightedText(label: "Duration ⏰", colour: sleepColour),
          DurationTimer(onStateChanged: onDurationTimerStateChange),
          TextField(
              decoration: const InputDecoration(
                label: Text("Note 📝"),
                hintText: "Write note here",
              ),
              controller: inputNoteController
          ),
          ElevatedButton.icon(
              onPressed: () {submitSleep(babyEventChangeNotifier);},
              icon: const Icon(Icons.save, color: Colors.white,),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              label: Text(saveBtnLbl, style: const TextStyle(color: Colors.white),)
          ),
        ],
      ),
    ),
  );
  }
}
