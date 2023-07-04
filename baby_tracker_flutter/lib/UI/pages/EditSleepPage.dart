import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Entity/BabyEventChangeNotifier.dart';
import '../../Entity/Feed.dart';
import '../../Entity/Sleep.dart';
import '../common_widgets/DateTimeSelector.dart';

class EditSleepPage extends StatefulWidget {
  const EditSleepPage({super.key, required this.id});

  final String id;

  @override
  State<EditSleepPage> createState() => _EditSleepPageState();
}

class _EditSleepPageState extends State<EditSleepPage> {
  final Color sleepColour = Colors.purple;

  // State
  String _startDate = "";
  String _startTime = "";
  String saveBtnLbl = "Save Changes";

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

  void saveUpdate(){
    String startDate = _startDate;
    String startTime = _startTime;
    String duration = '${inputHoursController.text},${inputMinutesController.text},${inputSecondsController.text}';
    String note = inputNoteController.text;

    Sleep updatedFeed = Sleep(
        startDate: startDate,
        startTime: startTime,
        duration: duration,
        note: note
    );

    setState(() {
      saveBtnLbl = "Saving...";
    });

    Provider.of<BabyEventChangeNotifier>(context, listen: false).updateBabyEvent(widget.id, updatedFeed, onSuccessfulSave);
  }

  void onSuccessfulSave(){
    Navigator.pop(context);
    _showToast();
  }

  void _showToast() {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Sleep successfully updated!"),
            content: Image.asset("assets/party.gif"),
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
  void initState() {
    super.initState();
    Sleep sleep = Provider.of<BabyEventChangeNotifier>(context, listen: false).get(widget.id) as Sleep;

    _startDate = sleep.startDate;
    _startTime = sleep.startTime;

    List<String> durationValues = sleep.duration.split(",");
    inputHoursController.text = durationValues[0];
    inputMinutesController.text = durationValues[1];
    inputSecondsController.text = durationValues[2];

    inputNoteController.text = sleep.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text("Edit Sleep 😴"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HighlightedText(label: "Start Time 🕒️", colour: sleepColour),
              DateTimeSelector(onStateChange: onDateTimeSelectorStateChange, initialDate: _startDate, initialTime: _startTime,),
              HighlightedText(label: "Duration ⏰️️", colour: sleepColour),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: TextField(
                        decoration: const InputDecoration(label: Text("Hours")),
                        keyboardType: TextInputType.number,
                        controller: inputHoursController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 70,
                        child: TextField(
                          decoration: const InputDecoration(label: Text("Minutes")),
                          keyboardType: TextInputType.number,
                          controller: inputMinutesController,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        decoration: const InputDecoration(label: Text("Seconds")),
                        keyboardType: TextInputType.number,
                        controller: inputSecondsController,
                      ),
                    ),
                  ]),
              TextField(
                  decoration: const InputDecoration(
                    label: Text("Note 📝"),
                    hintText: "Write note here",
                  ),
                  controller: inputNoteController),
              ElevatedButton.icon(
                onPressed: saveUpdate,
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
                label: Text(
                  saveBtnLbl,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
