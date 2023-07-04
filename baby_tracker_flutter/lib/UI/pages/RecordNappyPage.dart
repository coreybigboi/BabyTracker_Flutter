
import 'dart:io';

import 'package:baby_tracker_flutter/Entity/BabyEventChangeNotifier.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/DateTimeSelector.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Entity/Nappy.dart';

class RecordNappyPage extends StatefulWidget {
  const RecordNappyPage({super.key});

  @override
  State<RecordNappyPage> createState() => _RecordNappyPageState();
}

class _RecordNappyPageState extends State<RecordNappyPage> {

  final Color nappyColour = const Color(0xFF00008b);
  final CollectionReference babyEventCollection = FirebaseFirestore.instance.collection("babyEvents");

  // State
  String _startDate = "";
  String _startTime = "";
  String _nappyType = "Wet";
  String saveBtnLbl = "Save Nappy";
  File? image;

  // Controllers
  var inputNoteController = TextEditingController();

  // Handler for Start Time Widget
  void onDateTimeSelectorStateChange(String date, String time){
    _startDate = date;
    _startTime = time;
  }

  submitNappy(BabyEventChangeNotifier babyEventChangeNotifier){
    String startDate = _startDate;
    String startTime = _startTime;
    String nappyType = _nappyType;
    String note = inputNoteController.text;
    Nappy newNappy = Nappy(
        startDate: startDate,
        startTime: startTime,
        nappyType: nappyType,
        note: note
    );
    setState(() {
      saveBtnLbl = "Saving...";
    });

    babyEventChangeNotifier.add(newNappy, onSuccessfulSave);
  }

  void onSuccessfulSave(){
    resetState();
    _showToast("Nappy successfully recorded");
  }

  void resetState(){
    setState(() {
      _startDate = "";
      _startTime = "";
      saveBtnLbl = "Save Nappy";
      inputNoteController.text = "";
    });
  }

  void _showToast(String message) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Nappy successfully recorded!"),
            content: Image.asset("assets/nappy.gif"),
            actions: [
              TextButton(
                onPressed: () { Navigator.pop(context); },
                child: const Text("ok", style: TextStyle(color: Colors.blue, fontSize: 20)),
              ),
            ],
          );
        });
  }

  Future pickImage() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BabyEventChangeNotifier>(builder: buildRecordNappyPage);
  }

  Center buildRecordNappyPage(BuildContext context, BabyEventChangeNotifier babyEventChangeNotifier, _) {
    return Center(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HighlightedText(label: "Start Time 🕒️", colour: nappyColour),
          DateTimeSelector(onStateChange: onDateTimeSelectorStateChange),
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  // Provide an onPressed callback.
                  onPressed: () {pickImage();},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  icon: const Icon(Icons.camera_alt, color: Colors.white,),
                  label: const Text("Choose Photo", style: TextStyle(color: Colors.white),),
                ),
              ),
              if(image != null) Image.file(
                image!,
                height: 80,
                width: 80,
              )
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
              onPressed: () {submitNappy(babyEventChangeNotifier);},
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
