import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Entity/BabyEventChangeNotifier.dart';
import '../../Entity/Nappy.dart';
import '../common_widgets/DateTimeSelector.dart';

class EditNappyPage extends StatefulWidget {
  const EditNappyPage({super.key, required this.id});

  final String id;

  @override
  State<EditNappyPage> createState() => _EditNappyPageState();
}

class _EditNappyPageState extends State<EditNappyPage> {
  final Color nappyColour = const Color(0xFF00008b);

  // State
  String _startDate = "";
  String _startTime = "";
  String _nappyType = "Wet";
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
    String nappyType = _nappyType;
    String note = inputNoteController.text;

    Nappy updatedNappy = Nappy(
        startDate: startDate,
        startTime: startTime,
        nappyType: nappyType,
        note: note
    );

    setState(() {
      saveBtnLbl = "Saving...";
    });

    Provider.of<BabyEventChangeNotifier>(context, listen: false).updateBabyEvent(widget.id, updatedNappy, onSuccessfulSave);
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
            title: const Text("Nappy successfully updated!"),
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
    Nappy nappy = Provider.of<BabyEventChangeNotifier>(context, listen: false).get(widget.id) as Nappy;

    _startDate = nappy.startDate;
    _startTime = nappy.startTime;
    _nappyType = nappy.nappyType;
    inputNoteController.text = nappy.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Edit Nappy 🚼"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HighlightedText(label: "Start Time 🕒️", colour: nappyColour),
              DateTimeSelector(onStateChange: onDateTimeSelectorStateChange, initialDate: _startDate, initialTime: _startTime,),
              HighlightedText(label: "Nappy Type 🚼", colour: nappyColour),
              DropdownButton<String>(
                value: _nappyType,
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String? newValue) {
                  if(newValue == null) return;
                  setState(() {
                    _nappyType = newValue;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "Wet", child: Text("Wet 💧")),
                  DropdownMenuItem(value: "Wet & Dirty", child: Text("Wet & Dirty 💧💩")),
                ],
              ),
              TextField(
                  decoration: const InputDecoration(
                    label: Text("Note 📝"),
                    hintText: "Write note here",
                  ),
                  controller: inputNoteController
              ),
              ElevatedButton.icon(
                  onPressed: () {saveUpdate();},
                  icon: const Icon(Icons.save, color: Colors.white,),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  label: Text(saveBtnLbl, style: const TextStyle(color: Colors.white),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
