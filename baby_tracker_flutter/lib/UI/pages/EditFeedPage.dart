import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Entity/BabyEventChangeNotifier.dart';
import '../../Entity/Feed.dart';
import '../common_widgets/DateTimeSelector.dart';

class EditFeedPage extends StatefulWidget {
  const EditFeedPage({super.key, required this.id});

  final String id;

  @override
  State<EditFeedPage> createState() => _EditFeedPageState();
}

class _EditFeedPageState extends State<EditFeedPage> {
  final Color feedColour = const Color(0xFFa71a40);

  // State
  String _startDate = "";
  String _startTime = "";
  String _feedType = "Left Side";
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
    String feedType = _feedType;
    String note = inputNoteController.text;

    Feed updatedFeed = Feed(
        startDate: startDate,
        startTime: startTime,
        duration: duration,
        feedType: feedType,
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
            title: const Text("Feed successfully updated!"),
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
    Feed feed = Provider.of<BabyEventChangeNotifier>(context, listen: false).get(widget.id) as Feed;

    _startDate = feed.startDate;
    _startTime = feed.startTime;

    List<String> durationValues = feed.duration.split(",");
    inputHoursController.text = durationValues[0];
    inputMinutesController.text = durationValues[1];
    inputSecondsController.text = durationValues[2];

    _feedType = feed.feedType;
    inputNoteController.text = feed.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Edit Feed 🤱"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HighlightedText(label: "Start Time 🕒️", colour: feedColour),
              DateTimeSelector(onStateChange: onDateTimeSelectorStateChange, initialDate: _startDate, initialTime: _startTime,),
              HighlightedText(label: "Duration ⏰️️", colour: feedColour),
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
              HighlightedText(label: "Feed Type 🤱", colour: feedColour),
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
