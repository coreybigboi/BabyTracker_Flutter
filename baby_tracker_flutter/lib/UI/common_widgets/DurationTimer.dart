import 'package:flutter/material.dart';
import 'dart:async';

class DurationTimer extends StatefulWidget {
  const DurationTimer({super.key, required this.onStateChanged});

  final Function onStateChanged;

  @override
  State<DurationTimer> createState() => _DurationTimerState();
}

class _DurationTimerState extends State<DurationTimer> {

  // State
  int _durationHours = 0;
  int _durationMinutes = 0;
  int _durationSeconds = 0;
  bool timerActive = false;

  // Controllers
  var inputHoursController = TextEditingController();
  var inputMinutesController = TextEditingController();
  var inputSecondsController = TextEditingController();

  Future<void> startTimer() async {
    if(timerActive) return;
    timerActive = true;
    while (timerActive) {
      await Future.delayed(const Duration(seconds: 1));
      if(!timerActive) return;
      incrementTimer();
      setDurationFields();
      widget.onStateChanged(_durationHours, _durationMinutes, _durationSeconds);
    }
  }

  void stopTimer(){
    setState(() {
      timerActive = false;
    });
    widget.onStateChanged(_durationHours, _durationMinutes, _durationSeconds);
  }

  void resetTimer(){
    setState(() {
      _durationHours = 0;
      _durationMinutes = 0;
      _durationSeconds = 0;
      timerActive = false;
    });
    setDurationFields();
    widget.onStateChanged(_durationHours, _durationMinutes, _durationSeconds);
  }

  void incrementTimer(){
    setState(() {
      _durationSeconds++;

      if(_durationSeconds >= 60){
        _durationSeconds = 0;
        _durationMinutes++;
      }

      if(_durationMinutes >= 60){
        _durationMinutes = 0;
        _durationHours++;
      }
    });
  }

  void setDurationFields(){
    inputHoursController.text = _durationHours.toString();
    inputMinutesController.text = _durationMinutes.toString();
    inputSecondsController.text = _durationSeconds.toString();
  }

  @override
  void initState() {
    super.initState();
    //setDurationFields();
    widget.onStateChanged(_durationHours, _durationMinutes, _durationSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: TextField(
                decoration: const InputDecoration(label: Text("Hours")),
                keyboardType: TextInputType.number,
                controller: inputHoursController,
                onChanged: (value) {
                    _durationHours = inputHoursController.text != "" ? int.parse(value) : 0;
                    widget.onStateChanged(_durationHours, _durationMinutes, _durationSeconds);
                  },
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
                  onChanged: (value) {
                    _durationMinutes = inputMinutesController.text != "" ? int.parse(value) : 0;
                    widget.onStateChanged(_durationHours, _durationMinutes, _durationSeconds);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 70,
              child: TextField(
                decoration: const InputDecoration(label: Text("Seconds")),
                keyboardType: TextInputType.number,
                controller: inputSecondsController,
                onChanged: (value) {
                  _durationSeconds = inputSecondsController.text != "" ? int.parse(value) : 0;
                  widget.onStateChanged(_durationHours, _durationMinutes, _durationSeconds);
                },
              ),
            ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ElevatedButton.icon(
                        onPressed: timerActive ? null : startTimer,
                        icon: const Icon(Icons.play_arrow, color: Colors.white,),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                        label: const Text("Start", style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ElevatedButton.icon(
                        onPressed: stopTimer,
                        icon: const Icon(Icons.stop, color: Colors.white,),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                        label: const Text("Stop", style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ElevatedButton.icon(
                        onPressed: resetTimer,
                        icon: const Icon(Icons.restart_alt, color: Colors.white,),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                        label: const Text("Reset", style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ]),
            ),
          ]);
  }
}
