import 'package:flutter/material.dart';

class DateTimeSelector extends StatefulWidget {
  const DateTimeSelector({super.key, required this.onStateChange, this.initialDate = "", this.initialTime = ""});

  final Function onStateChange;
  final String initialDate;
  final String initialTime;

  @override
  State<DateTimeSelector> createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {

  // State
  String _date = "";
  String _time = "";

  void _showDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
    ).then((value) {
      if(value == null) return;
      setState(() {
        _date = formatDate(value);
      });
      widget.onStateChange(_date, _time);
    });
  }

  void _showTimePicker(){
    showTimePicker(context: context, initialTime: TimeOfDay.now()
    ).then((value) {
      if(value == null) return;
      setState(() {
        _time = formatTime(value);
      });
      widget.onStateChange(_date, _time);
    });
  }

  String formatDate(DateTime date){
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return '$day-$month-$year';
  }

  String formatTime(TimeOfDay time){
    int hour = time.hour;
    int min = time.minute;
    String hourText = hour < 10 ? '0$hour' : '$hour';
    String minuteText = min < 10 ? '0$min' : '$min';
    //return time.format(context).toString();
    return '$hourText:$minuteText';
  }

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate == "" ? formatDate(DateTime.now()) : widget.initialDate;
    _time = widget.initialTime == "" ? formatTime(TimeOfDay.now()) : widget.initialTime;
    widget.onStateChange(_date, _time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month_rounded, color: Colors.white,),
                  onPressed: _showDatePicker,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  label: const Text(
                    "Choose Date",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(_date, style: const TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                onPressed: _showTimePicker,
                icon: const Icon(Icons.access_time_filled, color: Colors.white,),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                label: const Text(
                  "Choose Time",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(_time, style: const TextStyle(fontSize: 20))
            )
          ],
        ),
      ],
    );
  }
}
